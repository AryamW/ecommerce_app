import 'package:ecommerce_app/domain/entities/product.dart';

import '../repositories/search_product_repository.dart';
import 'search_product_usecase.dart';

class SearchProductsUseCaseImpl implements SearchProductsUseCase{
 final SearchProductsRepository searchRepo;

 
SearchProductsUseCaseImpl({required this.searchRepo});


  @override
  Future<Result<ProductResponseModel>> call({required SearchModel searchModel}) async {
    try {
      return await searchRepo.searchProducts(searchModel);
    } catch (e) {
      rethrow;
    }
  }

 
  
}