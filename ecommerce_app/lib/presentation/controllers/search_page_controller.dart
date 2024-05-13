import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/product.dart';
import '../../domain/usecases/search_product_usecase.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'expansion_controller.dart';
import 'search_text_controller.dart';

class SearchPageController extends GetxController {
  RxInt offset = 0.obs;
  RxInt total = 0.obs;
  // String? initialWord;
  var selectedFilters = [].obs;
  // var searchWord = ''.obs;
  bool valid = false;
  RxnString confirmError = RxnString(null);
  var sortType = "NONE".obs;
  var currentChoice = "None".obs;
  int currentPage = 0;
  SearchController searchWordController =
      Get.find<SearchTextController>().searchController;

  late ExpansionController expansionController;

  final PagingController<int, Product> _pagingController =
      PagingController<int, Product>(firstPageKey: 0, invisibleItemsThreshold: 5);
//  final RestClient restClient = RestClient();

  final List<Product> newItems = [];
  final SearchProductsUseCase searchProductsUseCase;

  SearchPageController(this.searchProductsUseCase) {
    _pagingController.addPageRequestListener((pageKey) {
      loadPage(pageKey);
    });
    // Load the first page
    // if(initialWord!=null) {searchWordController.=initialWord!;}
    expansionController = Get.put(ExpansionController());
    // loadPage(offset.value);
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
            .hasMatch(searchWordController.value.text.removeAllWhitespace) &&
        searchWordController.value.text.removeAllWhitespace.isNotEmpty) {
      valid = true;
    } else {
      valid = false;
      confirmError.value = 'Please enter a valid search';
    }
  }


  CancelToken? _cancelToken; // Token to cancel the Dio request
  List<CancelToken> cancelTokens = [];


  PagingController<int, Product> get pagingController => _pagingController;

  void loadPage(int pageKey) {
    _cancelToken = CancelToken(); // Create a new cancel token for each request
      // await Future.delayed(Duration(milliseconds: 500));
    validateSearchWord();
    try{if (valid && _pagingController.nextPageKey!=null) {
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
          searchModel:_searchModel).then((value) {
            newItem = value;
        cancelTokens.remove(_cancelToken);
              // SearchModel(searchWord: searchWordController.value.text,low: low,high: high,maxSize: maxSize,start: pageKey, category: "Elec"));
      if (newItem.data != null && currentPage != newItem.data!.nextIndex) {
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
    searchWordController.clear();
    // _pagingController.dispose();
    super.onClose();
  }

  @override
  void refresh(){
    offset.value=0;
    total.value = 0;
    newItems.clear();
    currentPage = 0;
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
