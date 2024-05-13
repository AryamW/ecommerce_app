import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/product.dart';
import '../../domain/usecases/search_product_usecase.dart';

import 'expansion_controller.dart';
// import 'search_text_controller.dart';

class AdminTableController extends GetxController {
  RxInt offset = 0.obs;
  RxInt total = 0.obs;
  RxInt? nextPageKey = 0.obs;
  // String? initialWord;
  var selectedFilters = [].obs;
  // var searchWord = ''.obs;
  bool valid = false;
  RxnString confirmError = RxnString(null);
  int currentPage = 0;
  SearchController searchWordController = SearchController();

  late ExpansionController expansionController;


  final List<Product> newItems = [];
  final RxList results = [].obs;
  final SearchProductsUseCase searchProductsUseCase;
  var sortType = "NONE".obs;
  var currentChoice = "None".obs;

  AdminTableController(this.searchProductsUseCase) {
    expansionController = Get.put(ExpansionController());
    // loadPage(offset.value);
      loadPage(nextPageKey?.value);
    // Load the first page
  }

  void addFilter(String filter) {
    selectedFilters.add(filter);
  }

  void removeFilter(String filter) {
    selectedFilters.remove(filter);
  }

  void setSortType(int sorttypeIndex){
    if(sorttypeIndex == 0 ){sortType.value = ("NONE");}
    if(sorttypeIndex == 1 ){sortType.value = ("PRICE_ASCENDING");}
    if(sorttypeIndex == 2 ){sortType.value = ("PRICE_DESCENDING");}
  refresh();
}





  final RegExp alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
  void validateSearchWord() {
    if (alphanumericRegex
            .hasMatch(searchWordController.value.text.removeAllWhitespace) ||
        searchWordController.value.text.removeAllWhitespace.isNotEmpty) {
      valid = true;
    } else {
      valid = false;
      confirmError.value = 'Please enter a valid search';
    }
  }

void loadNextPage(){
  loadPage(nextPageKey?.value);
}
  CancelToken? _cancelToken; // Token to cancel the Dio request
  List<CancelToken> cancelTokens = [];

  void loadPage(int? pageKey) {
    _cancelToken = CancelToken(); // Create a new cancel token for each request
      // await Future.delayed(Duration(milliseconds: 500));
    // validateSearchWord();
    if ( nextPageKey!=null) {
    try {
      List<String> category = selectedFilters.map((element) => element ?? "").toList().cast<String>();
      int? low = int.tryParse(expansionController.minController.text);
      int? high = int.tryParse(expansionController.maxController.text);
      int maxSize = int.tryParse(expansionController.pageSize.single) ?? 10;
      SearchModel _searchModel = SearchModel(searchWord: searchWordController.value.text);
      _searchModel.low = low;
      _searchModel.high= high;
      _searchModel.start = pageKey;
      _searchModel.maxSize = maxSize;
      _searchModel.sortType = sortType.value;
      if(category.isNotEmpty){
      _searchModel.category = category;
      }
      
      if (offset.value != -1 && _cancelToken!=null){
        cancelTokens.add(_cancelToken!);
        Result<ProductResponseModel> newItem;
        SearchProduct(_cancelToken!,
          searchModel:_searchModel).then((value){
              // SearchModel(searchWord: searchWordController.value.text,low: low,high: high,maxSize: maxSize,start: pageKey, category: "Elec"));
        newItem = value;
        cancelTokens.remove(_cancelToken);
      if (newItem.data != null  &&  currentPage != newItem.data!.nextIndex) {
        newItems.clear();
        newItems.addAll(newItem.data!.productDtos);
        offset.value = newItem.data!.nextIndex;
        currentPage = newItem.data!.nextIndex;
        if (total.value == 0)total.value = newItem.data!.total;// Check if we have more items to load
      final isLastPage = offset.value==-1;
      if (isLastPage) {
        nextPageKey = null;
        results.addAll(newItems);
      } else {
        nextPageKey = offset;
        results.addAll(newItems);
      }
      } else {
        //log error
        // print(newItem.error);
      }});
      }

      
    } catch (error) {
      //log error
      // print(error);
    }finally {
       _cancelToken = null; // Reset the cancel token
    }
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
    nextPageKey = RxInt(0);
    // print(nextPageKey);
    results.clear();
    for(var element in cancelTokens){ try{element.cancel();}catch(e){}};
    _cancelToken = null; //
    loadNextPage();
    // _pagingController.refresh();
    super.refresh();
  }

void clear(){
  selectedFilters.clear();
  expansionController.clear();
}

  Future<Result<ProductResponseModel>> SearchProduct(CancelToken cancelToken,
      {required SearchModel searchModel}) async {
    var result = await searchProductsUseCase.call(cancelToken, searchModel: searchModel);
    return result;
  }
}
