import 'package:ecommerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/presentation/controllers/admin_user.dart';
import 'package:ecommerce_app/presentation/pages/ErrorPage.dart';
import 'package:ecommerce_app/presentation/pages/search/search_results.dart';
import 'package:ecommerce_app/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MostProductsEntry extends StatelessWidget {
  var controller = Get.find<AdminUsersController>();

  MostProductsEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: backButton(),
        title: Text(
          "Most Popular Products",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: Center(
          child: Obx(() => MostPopularProducts(
              products: controller.mostPopularProducts.value))),
    );
  }
}

class OutOfStockProductEntry extends StatelessWidget {
  var controller = Get.find<AdminUsersController>();

  OutOfStockProductEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: backButton(),
        title: Text(
          "Out Of Stock Products",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: Center(
        child: Obx(() =>
            OutOfStockProducts(products: controller.mostPopularProducts.value)),
      ),
    );
  }
}

class MostPopularProducts extends StatelessWidget {
  final List<Product> products;
  MostPopularProducts({super.key, required this.products});
  final controller = Get.find<AdminUsersController>();
  @override
  Widget build(BuildContext context) {
    if (products.length == 0) {
      if (controller.mostPopularProductsError.isNotEmpty) {
        return Text(
          "${controller.mostPopularProductsError['status']}: ${controller.mostPopularProductsError['message']}",
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        );
      } else {
        return Text("No products to show.",
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary));
      }
    }
    return SingleChildScrollView(
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          ...products.map(
            (e) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.secondary,
              ),
              padding: EdgeInsets.all(16),
              width: 300,
              height: 300,
              child: AdminProductCard(
                index: e.id,
                product: e,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OutOfStockProducts extends StatelessWidget {
  var controller = Get.find<AdminUsersController>();
  final List<Product> products;
  OutOfStockProducts({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    print(products.length);
    if (products.length == 0) {
      if (controller.outOfStockProductsError.isNotEmpty) {
        return Text(
          "${controller.outOfStockProductsError['status']}: ${controller.outOfStockProductsError['message']}",
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        );
      } else {
        return Text("No products to show.",
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary));
      }
    }
    return SingleChildScrollView(
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          ...products.map(
            (e) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.secondary,
              ),
              width: 300,
              height: 300,
              child: AdminProductCard(
                index: e.id,
                product: e,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AdminProductCard extends StatelessWidget {
  final Product product;
  final int index;
  const AdminProductCard(
      {super.key, required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed('/adminEditProducts', arguments: {'product': product}),
      child: Card(
        color: Theme.of(context).colorScheme.secondary,
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: product.imageUrl.isNotEmpty
                  ? Image.network(
                      product.imageUrl.isNotEmpty
                          ? product.imageUrl[0]
                          : 'https://via.placeholder.com/250',
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
                    )
                  : Image.asset(
                      "lib/assets/images/DefaultImage.jpg",
                      width: double.maxFinite,
                      fit: BoxFit.contain, // Cover the available space
                    ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10 / 4, horizontal: 10),
              child: Text(
                product.name,
                maxLines: 2,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                overflow: TextOverflow.fade,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "\$${product.price}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
