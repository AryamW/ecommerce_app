import 'package:ecommerce_app/main.dart';
import 'package:ecommerce_app/presentation/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import '../../../controllers/home_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../domain/entities/product.dart';

class HomeResult extends StatelessWidget {
 final HomePageController productController = Get.find<HomePageController>();
 final ScrollController _scrollController = ScrollController();
 @override
 Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      onRefresh: () => Future.sync(() => productController.refresh()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Obx( ()=>
           Stack(
            children: [PagedGridView<int, Product>(
              scrollController: _scrollController,
              showNewPageProgressIndicatorAsGridChild: false,
              showNewPageErrorIndicatorAsGridChild: false,
              showNoMoreItemsIndicatorAsGridChild: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:  Get.find<ThemeController>().viewType.value?
                          ((MediaQuery.of(context).size.width * 0.007).floor() > 0 ? (MediaQuery.of(context).size.width * 0.007).floor() : 1) 
                          : 
                          ((MediaQuery.of(context).size.width * 0.003).floor() > 0 ? (MediaQuery.of(context).size.width * 0.003).floor() : 1),
                          childAspectRatio: Get.find<ThemeController>().viewType.value? 1 :3,
                        ),
              pagingController: productController.pagingController,
              builderDelegate: PagedChildBuilderDelegate<Product>(
                animateTransitions: true,
                itemBuilder: (context, product, index) =>  Get.find<ThemeController>().viewType.value?
                // GridTile(child: child),
                ProductCard(product: product,index: index,)
                 :
                ProductTile(product: product, index: index),
                // ListTile(
                //   leading: Image.network(product.imageUrl),
                //   title: Text(product.name),
                //   subtitle: Text('${product.price.toStringAsFixed(2)} ETB'),
                // ),
                noMoreItemsIndicatorBuilder: (_) => Container(alignment: Alignment.center, height: 100,child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("NO More Items",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
                    SizedBox(
                      child: TextButton(
                        onPressed: () => Get.toNamed("/category"),
                        child: Text("Explore"),
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Theme.of(context).colorScheme.tertiary),
                            foregroundColor: MaterialStatePropertyAll(
                                Theme.of(context).colorScheme.onPrimary),
                            // minimumSize: MaterialStatePropertyAll(25 as Size?),
                            ),
                      ),
                    ),
                  ],
                )),
                noItemsFoundIndicatorBuilder: (_) => ListTile(leading: Image.asset('lib/assets/images/search error.png'),title: Text("Sorry, we couldn't find any \nmatching results for your \nSearch",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),),
                firstPageProgressIndicatorBuilder: (context) => ListTile(title: Text("Loading More Items......",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),),
                // newPageProgressIndicatorBuilder: (_) => ListTile(title: Text("Loading More Items......",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),tileColor: Colors.green.shade200,),
                newPageProgressIndicatorBuilder: (context) => Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onPrimary,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary),
                  ),
                ),
                firstPageErrorIndicatorBuilder: (context) => Column(
                  children: [
                    Text("A problem was encountered. Please check your network and try again",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
                    SizedBox(
                      child: TextButton(
                        onPressed: () => productController.refresh(),
                        child: Icon(Icons.refresh),
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Theme.of(context).colorScheme.tertiary),
                            foregroundColor: MaterialStatePropertyAll(
                                Theme.of(context).colorScheme.onPrimary),
                            // minimumSize: MaterialStatePropertyAll(25 as Size?),
                            ),
                      ),
                    ),
                  ],
                ),
                newPageErrorIndicatorBuilder: (context) => Column(
                  children: [
                    Text("A problem was encountered. Please check your network and try again",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
                    SizedBox(
                      child: TextButton(
                        onPressed: () => productController.pagingController.retryLastFailedRequest(),
                        child: Icon(Icons.refresh),
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Theme.of(context).colorScheme.tertiary),
                            foregroundColor: MaterialStatePropertyAll(
                                Theme.of(context).colorScheme.onPrimary),
                            // minimumSize: MaterialStatePropertyAll(25 as Size?),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: IconButton(
                style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.secondaryContainer)),
              onPressed: () {
                _scrollController.animateTo(
                  0.0,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
              },
              icon: Icon(Icons.keyboard_arrow_up),
                      ),
            ),
            Obx(()=>Positioned(
              right: 0,
              bottom: 45,
              child: IconButton(
                style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.secondaryContainer)),
              onPressed: () {Get.find<ThemeController>().changeViewType();},
              icon: Get.find<ThemeController>().viewType.value? Icon(Icons.list) : Icon(Icons.grid_view_outlined),
                      ),
            ),)
            ]
          ),
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
    return GestureDetector(
      onTap: () => Get.toNamed("/productDetail",arguments: {"id":product.id}),
      child: 
      // Stack(
      //   children: [
          Card(
                  color: Theme.of(context).colorScheme.secondary,
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5,),
                      Expanded(
                        child: product.imageUrl.isNotEmpty?  Image.network(
                          product.imageUrl.isNotEmpty? product.imageUrl[0]:'https://via.placeholder.com/250',
                          width: double.maxFinite,
                          fit: BoxFit.contain, // Cover the available space
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              "https://red-ecommerce.onrender.com/images/DefaultImage.jpg",
                              width: double.maxFinite,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                    "lib/assets/images/DefaultImage.jpg");
                              },
                            );
                          },
                        ): Image.asset(
                          "lib/assets/images/DefaultImage.jpg",
                          width: double.maxFinite,
                          fit: BoxFit.contain, // Cover the available space
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10 / 4, horizontal: 10),
                        child: Text(
                          "${product.name}",
                          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "${product.price} ETB",
                          style: TextStyle(fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
                // Positioned(top: -10,right: -10,
                //   child: HeartButton()),
      //           ],
      // ),
    );
  }
}


class ProductTile extends StatelessWidget {
  final Product product;
  final int index;
  const ProductTile({super.key, required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed("/productDetail",arguments: {"id":product.id}),
      child: 
          Card(
            color: Theme.of(context).colorScheme.secondary,
            child: SizedBox(
              height: 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5,top: 5,bottom: 5),
                    child: product.imageUrl.isNotEmpty?  Image.network(
                      product.imageUrl.isNotEmpty? product.imageUrl[0]:'https://via.placeholder.com/250',
                      fit: BoxFit.fitHeight, // Cover the available height
                      width: 150,
                      height: 150,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          "https://red-ecommerce.onrender.com/images/DefaultImage.jpg",
                      height: 150,
                      width: 150,
                          fit: BoxFit.fitHeight,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                                "lib/assets/images/DefaultImage.jpg");
                          },
                        );
                      },
                    ): Image.asset(
                      "lib/assets/images/DefaultImage.jpg",
                      fit: BoxFit.fitHeight, // Cover the available height
                    ),
                  ),
                  Expanded(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10 / 4, horizontal: 10),
                          child: Text(
                            "${product.name}",
                            softWrap: true,
                            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                            overflow: TextOverflow.fade,
                            maxLines: 3,
                          ),
                        ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "${product.price} ETB",
                        style: TextStyle(fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary),
                        maxLines: 3,
                        softWrap: true,
                      ),
                    ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}