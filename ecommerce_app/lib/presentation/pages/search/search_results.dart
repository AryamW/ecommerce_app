import 'package:ecommerce_app/presentation/controllers/search_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../domain/entities/product.dart';

class SearchResult extends StatelessWidget {
 final SearchPageController productController = Get.find<SearchPageController>();

 @override
 Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(() => productController.pagingController.refresh()),
      child: PagedGridView<int, Product>(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (MediaQuery.of(context).size.width * 0.004).floor(),
                    childAspectRatio: 1.0,
                  ),
        pagingController: productController.pagingController,
        builderDelegate: PagedChildBuilderDelegate<Product>(
          itemBuilder: (context, product, index) => 
          // GridTile(child: child),
          ProductCard(product: product,index: index,),
          // ListTile(
          //   leading: Image.network(product.imageUrl),
          //   title: Text(product.name),
          //   subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
          // ),
          noMoreItemsIndicatorBuilder: (_) => Container(alignment: Alignment.center, child: Text("NO More Items",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),)),
          noItemsFoundIndicatorBuilder: (_) => ListTile(leading: Image.asset('lib/assets/images/search error.png'),title: Text("Sorry, we couldn't find any \nmatching results for your \nSearch",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),),
          firstPageProgressIndicatorBuilder: (context) => ListTile(title: Text("Loading More Items......",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),),
          newPageProgressIndicatorBuilder: (_) => ListTile(title: Text("Loading More Items......",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),tileColor: Colors.green.shade200,),
        ),
      ),
    );
 }
}


class ProductCard extends StatelessWidget {
  final Product product;
  final int index;
  const ProductCard({super.key, required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
              color: Theme.of(context).colorScheme.secondary,
              elevation: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(
                        product.imageUrl,
                        width: double.maxFinite,
                        fit: BoxFit.contain, // Cover the available space
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10 / 4, horizontal: 10),
                    child: Text(
                      "$index${product.name}",
                      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "\$${product.price}",
                      style: TextStyle(fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ],
              ),
            );
  }
}