import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../domain/entities/product.dart';
import '../../domain/usecases/search_product_usecase.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'expansion_controller.dart';

class CategoryPageController extends GetxController {
  RxInt offset = 0.obs;
  RxInt total = 0.obs;
  // String? initialWord;
  final List<String?> selectedCategory = [Get.parameters["category"]];
  // var searchWord = ''.obs;
  RxnString confirmError = RxnString(null);
  int currentPage = 0;
  late ExpansionController expansionController;

  final PagingController<int, Product> _pagingController =
      PagingController<int, Product>(firstPageKey: 0, invisibleItemsThreshold: 5);
//  final RestClient restClient = RestClient();

  final List<Product> newItems = [];
  final SearchProductsUseCase searchProductsUseCase;

  CategoryPageController(this.searchProductsUseCase) {
    _pagingController.addPageRequestListener((pageKey) {
      loadPage(pageKey);
    });
  }


  CancelToken? _cancelToken; // Token to cancel the Dio request
  List<CancelToken> cancelTokens = [];

  PagingController<int, Product> get pagingController => _pagingController;

  void loadPage(int pageKey) {
    _cancelToken = CancelToken(); // Create a new cancel token for each request
      // await Future.delayed(Duration(seconds: 2));
    try{if ( _pagingController.nextPageKey!=null) {
    try {
      int maxSize = 10;
      SearchModel _searchModel = SearchModel();
      _searchModel.start = pageKey;
      _searchModel.maxSize = maxSize;
      _searchModel.category = selectedCategory;
      
      if (offset.value != -1 && _cancelToken!=null){
        cancelTokens.add(_cancelToken!);
        Result<ProductResponseModel> newItem;
        SearchProduct(_cancelToken!,
          searchModel:_searchModel).then((value) {
            newItem = value;
        cancelTokens.remove(_cancelToken);
      if (newItem.data != null &&  currentPage != newItem.data!.nextIndex) {
        newItems.clear();
        newItems.addAll(newItem.data!.productDtos);
        offset.value = newItem.data!.nextIndex;
        currentPage = newItem.data!.nextIndex;
        if (total.value == 0)total.value = newItem.data!.total;
      // Check if we have more items to load
      final isLastPage = offset.value==-1;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = offset.value;
        _pagingController.appendPage(newItems, nextPageKey);
      }
      } else {
        //log error
        // print(newItem.error);
        if(newItem.error != "Request canceled by user"){
       _pagingController.error = newItem.error;}
      }});
      }

    } catch (error) {
      _pagingController.error = error;
      //log error
      // print(error);
    }finally {
       _cancelToken = null; // Reset the cancel token
    }
  }
  }catch(e){
    _pagingController.error = e;
  } finally {
       _cancelToken = null; // Reset the cancel token
    }
  }

  @override
  void onClose() {
    offset.value=0;
    total.value = 0;
    currentPage = 0;
    newItems.clear();
    cancelTokens.clear();
    _cancelToken = null; //
    // _pagingController.dispose();
    super.onClose();
  }

  @override
  void refresh(){
    offset.value=0;
    total.value = 0;
    currentPage = 0;
    newItems.clear();
    for(var element in cancelTokens){ try{element.cancel();}catch(e){_pagingController.error = e;}};
    _cancelToken = null; //
    
    cancelTokens.clear();
    _pagingController.value = PagingState<int, Product>(
      nextPageKey: _pagingController.firstPageKey,
      error: null,
      itemList: null,
    );
    loadPage(_pagingController.firstPageKey);
    super.refresh();
  }

  Future<Result<ProductResponseModel>> SearchProduct(CancelToken cancelToken,
      {required SearchModel searchModel}) async {
    var result = await searchProductsUseCase.call(cancelToken,searchModel: searchModel);
    return result;
  }
}
