import 'package:dio/dio.dart';
import '../../domain/entities/product.dart';

abstract class SearchProductsDataSource{
  Future<ProductResponseModel> searchProducts(CancelToken cancelToken,SearchModel searchModel);
}