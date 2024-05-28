import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/utils/exceptions.dart';
import 'package:ecommerce_app/core/utils/handleExceptions.dart';
import 'package:ecommerce_app/data/datasources/search_product_data_source.dart';
import 'package:ecommerce_app/domain/usecases/search_product_usecase.dart';

import '../../domain/entities/product.dart';
import '../../domain/repositories/search_product_repository.dart';

class SearchProductsRepositoryImpl implements SearchProductsRepository{
  final SearchProductsDataSource searchRepo;

  SearchProductsRepositoryImpl({required this.searchRepo});
  
    @override
      Future<Result<ProductResponseModel>> searchProducts(CancelToken cancelToken,SearchModel searchModel) async{
      try {
      final resultData = await searchRepo.searchProducts(cancelToken, searchModel);
    //  if (resultData.productDtos.isNotEmpty) {
       return Result(data: resultData);
    //  }

    //  return Result(error: 'No products found');
   }on CustomeException catch (e) {
     return Result(error: e.message);
   }  catch (e) {
     return Result(error: 'Failed to fetch products');
   } 
    
    }

}