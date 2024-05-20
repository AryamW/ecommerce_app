import 'package:ecommerce_app/presentation/controllers/category_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/data_sources/search_product_data_source.dart';
import '../../../../data/data_sources/search_products_data_source_impl.dart';
import '../../../../data/repositories/search_product_repository_impl.dart';
import '../../../../domain/repositories/search_product_repository.dart';
import '../../../../domain/usecases/search_product_usecase.dart';
import '../../../../domain/usecases/search_product_usecase_impl.dart';
import 'category_result.dart';

class SelectedCategoryPage extends StatelessWidget {
  SelectedCategoryPage({super.key});
  final String selectedCategory = Get.parameters["category"]??"category";
  @override
  Widget build(BuildContext context) {
final SearchProductsDataSource searchProductsDataSource = SearchProductsDataSourceImpl();
 final SearchProductsRepository searchProductsRepository = SearchProductsRepositoryImpl(searchRepo: searchProductsDataSource);
final SearchProductsUseCase searchProductsUseCase = SearchProductsUseCaseImpl(searchRepo: searchProductsRepository);
  final CategoryPageController controller = Get.put(CategoryPageController(searchProductsUseCase));
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 25),
            child: Ink(
                decoration: ShapeDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: CircleBorder()),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: ImageIcon(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    AssetImage(
                                      "lib/assets/images/arrowleft2.png",
                                    ),
                                  ),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 5),
            child: Text(
              selectedCategory,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            child: CategoryResult(),
          ),
        ],
      ),
    );
  }
}
