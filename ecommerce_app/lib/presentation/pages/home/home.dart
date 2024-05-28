import 'package:ecommerce_app/presentation/controllers/home_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/datasources/search_product_data_source.dart';
import '../../../data/datasources/search_products_data_source_impl.dart';
import '../../../data/repositories/search_product_repository_impl.dart';
import '../../../domain/repositories/search_product_repository.dart';
import '../../../domain/usecases/search_product_usecase.dart';
import '../../../domain/usecases/search_product_usecase_impl.dart';
import 'components/body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    
final SearchProductsDataSource searchProductsDataSource = SearchProductsDataSourceImpl();
 final SearchProductsRepository searchProductsRepository = SearchProductsRepositoryImpl(searchRepo: searchProductsDataSource);
final SearchProductsUseCase searchProductsUseCase = SearchProductsUseCaseImpl(searchRepo: searchProductsRepository);
    Get.put(HomePageController(searchProductsUseCase));
    return Body();
  }
}
