import 'package:ecommerce_app/core/utils/exceptions.dart';
import 'package:ecommerce_app/core/utils/roles.dart';
import 'package:ecommerce_app/domain/entities/cart.dart';
import 'package:ecommerce_app/presentation/controllers/auth.dart';
import 'package:ecommerce_app/presentation/controllers/cart.dart';
import 'package:ecommerce_app/presentation/controllers/checkout.dart';
import 'package:ecommerce_app/presentation/pages/ErrorPage.dart';
import 'package:ecommerce_app/presentation/pages/cart/emptyCart.dart';
import 'package:ecommerce_app/presentation/pages/products/product_detail.dart';
import 'package:ecommerce_app/presentation/widgets/button.dart';
import 'package:ecommerce_app/presentation/widgets/roleBasedAccessControlWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Cart_cart extends StatelessWidget {
  const Cart_cart({super.key});

  @override
  Widget build(BuildContext context) {
    CartController controller = Get.put(CartController());
    Get.put(CheckoutController());
    return AccessControlWidget(
      allowedRole: Roles.CUSTOMER,
      child: FutureBuilder(
        future: controller.fetchItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // return shimmer;
            return CartView(
                shimmer: true,
                cart:
                    CartModel(data: null, success: false, message: "Failed."));
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data == null &&
              !snapshot.hasError) {
            // null data but not from error;
            return EmptyCart();
          } else if (snapshot.hasError) {
            if (snapshot.error.runtimeType == BadResponseException) {
              return EmptyCart();
            } else {
              return ErrorPage(
                  message:
                      "Couldn't fetch cart items. Error Message:\n${snapshot.error.toString()}",
                  backDest: "/home");
            }
          } else {
            // return real show;
            return CartView(shimmer: false, cart: snapshot.data!);
          }
          // return SnackBar(content: Text("jflkajf"));
        },
      ),
    );
  }
}

class CartView extends StatelessWidget {
  final bool shimmer;
  final CartModel cart;
  const CartView({super.key, this.shimmer = false, required this.cart});

  @override
  Widget build(BuildContext context) {
    // bool success = cart.success;
    // String message = cart.message;
    // dataModel? data = cart.data;
    int? cartId = cart.data?.cartId;
    num? totalPrice = cart.data?.totalPrice;
    List<CartItem>? items = cart.data?.items;

    if (shimmer == false &&
        (cartId == null || totalPrice == null || items == null)) {
      return const ErrorPage(
        backDest: "/home",
        message:
            "something went wrong. Most likely a server Error. please try again later",
      );
    }
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Center(
        child: Container(
          width: 800,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            bottomNavigationBar: GestureDetector(
              onTap: () {
                Get.find<CheckoutController>().makePayment();
              },
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Theme.of(context).colorScheme.tertiary),
                  margin: EdgeInsets.all(20.0),
                  padding: EdgeInsets.all(16),
                  child: Center(
                      heightFactor: 1,
                      child: Text("Checkout",
                          style:
                              TextStyle(color: Colors.white, fontSize: 16)))),
            ),
            body: Container(
              color: Theme.of(context).colorScheme.primary,
              padding: EdgeInsets.all(20.0),
              child: Center(
                heightFactor: 1,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width < 800
                              ? MediaQuery.of(context).size.width
                              : 800,
                          child: Row(
                            children: [
                              const backButton(),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Cart",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            // Get.find<CartController>();
                          },
                          child: Text(
                            "Remove All",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        shimmer ? myShimmerForm() : myForm(items: items!),
                        SizedBox(
                          height: 120,
                        ),
                        shimmer
                            ? myShimmerTotal()
                            : myTotal(
                                total: totalPrice!,
                              ),
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class myShimmerTotal extends StatelessWidget {
  const myShimmerTotal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerContainer(
                width: 150,
                height: 30,
              ),
              ShimmerContainer(width: 100, height: 30),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerContainer(width: 150, height: 30),
              ShimmerContainer(width: 100, height: 30),
            ],
          ),
        ],
      ),
    );
  }
}

class myTotal extends StatelessWidget {
  final num total;
  const myTotal({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      height: 40,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Subtotal",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary)),
              Obx(() {
                var total =
                    Get.find<CartController>().cart.value.data!.totalPrice;
                return Text("${total} ETB",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary));
              }),
            ],
          ),
        ],
      ),
    );
  }
}

class myShimmerForm extends StatelessWidget {
  const myShimmerForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
        child: ListView.builder(
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ShimmerContainer(
              width: double.infinity,
              height: 80,
            ),
            SizedBox(
              height: 20,
            )
          ],
        );
      },
    ));
  }
}

class myForm extends StatelessWidget {
  final List<CartItem?> items;
  final cartConroller = Get.put(CartController());
  myForm({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Form(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount:
              Get.find<CartController>().cart.value.data?.items.length ?? 0,
          itemBuilder: (context, index) {
            // var item = items[index]!;
            // var product = item.product;
            return Column(
              children: [
                GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity == null) {
                    } else if (details.primaryVelocity! > 0.0 ||
                        details.primaryVelocity! < 0) {
                      Get.find<CartController>().deleteItem(
                          Get.find<CartController>()
                              .cart
                              .value
                              .data!
                              .items[index]
                              .updateToJson(0)!);
                      // Get.offAndToNamed("/cart");
                    }
                  },
                  // child: CartTile(
                  //     item: item,
                  //     imageUrl:
                  //         product.images!.map((e) => e.toString()).toList(),
                  //     price: product.price,
                  //     count: product.count,
                  //     title: product.name),
                  child: CartTile(index: index),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            );
          },
        ),
      );
    });
  }
}

class CartTile extends StatelessWidget {
  // final String title;
  // final CartItem item;
  // final int count;
  // final double price;
  // final List<String?> imageUrl;
  final int index;
  const CartTile(
      {super.key,
      // required this.title,
      // required this.count,
      // required this.price,
      // required this.imageUrl,
      // required this.item,
      required this.index});
  @override
  Widget build(BuildContext context) {
    String title =
        Get.find<CartController>().cart.value.data!.items[index].product.name;
    CartItem item = Get.find<CartController>().cart.value.data!.items[index];
    // print(item.product.images);
    print("image 0: ${item.product.images![0].toString()}");
    return Container(
        padding: EdgeInsets.all(10),
        // height: 80,
        color: Theme.of(context).colorScheme.secondary,
        // padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: item.product.images!.isNotEmpty
                  ? Image.network(
                      width: 64,
                      height: 64,
                      item.product.images![0].toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => SizedBox(
                        width: 64,
                        height: 64,
                        child: Container(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 64,
                      height: 64,
                      child: Container(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              flex: 3,
              child: Container(
                // height: 51,
                // color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Get.find<CartController>()
                              .cart
                              .value
                              .data!
                              .items[index]
                              .product
                              .name,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 12),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          "${item.price} ETB",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary),
                        )
                      ],
                    ),
                    Wrap(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 24,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (item.quantity >= item.product.count) {
                                    Get.snackbar(
                                        isDismissible: true,
                                        duration: Duration(seconds: 10),
                                        backgroundColor: ThemeData.dark()
                                            .colorScheme
                                            .secondary,
                                        colorText: ThemeData.dark()
                                            .colorScheme
                                            .onPrimary,
                                        "Excess",
                                        "Quantity has exceeded our stock.");
                                  } else {
                                    var value =
                                        item.updateToJson(item.quantity + 1);
                                    Get.find<CartController>()
                                        .updateItem(value!);
                                  }
                                },
                                icon: Icon(Icons.add),
                                style: ButtonStyle(
                                  alignment: Alignment.center,
                                  backgroundColor:
                                      MaterialStateColor.resolveWith((states) =>
                                          Theme.of(context)
                                              .colorScheme
                                              .tertiary),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero),
                                  iconSize: MaterialStateProperty.all(20),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${item.quantity}",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                onPressed: () {
                                  print("quantity: ${item.quantity}");
                                  if (item.quantity <= 1) {
                                    Get.find<CartController>()
                                        .deleteItem(item.updateToJson(0)!);
                                  } else {
                                    var value =
                                        item.updateToJson(item.quantity - 1);
                                    Get.find<CartController>()
                                        .updateItem(value!);
                                  }
                                },
                                icon: Icon(Icons.remove),
                                style: ButtonStyle(
                                  alignment: Alignment.center,
                                  backgroundColor:
                                      MaterialStateColor.resolveWith((states) =>
                                          Theme.of(context)
                                              .colorScheme
                                              .tertiary),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero),
                                  iconSize: MaterialStateProperty.all(20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          "in Stock: ${item.product.count}",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
