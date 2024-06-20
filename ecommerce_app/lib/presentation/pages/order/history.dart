import 'dart:ui';

import 'package:ecommerce_app/domain/entities/order.dart';
import 'package:ecommerce_app/presentation/controllers/order.dart';
import 'package:ecommerce_app/presentation/widgets/button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: backButton(),
        title: Text(
          "Orders",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: History(),
    );
  }
}

class History extends StatelessWidget {
  final controller = Get.put(OrderController());

  History({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print("length: ${controller.orders.length}");
      if (controller.orders.isEmpty) {
        print("here??");
        return Center(
            child: Text(
          "Empty History.",
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ));
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
        child: ListView.separated(
            itemBuilder: (context, index) {
              Order order = controller.orders[index];
              return GestureDetector(
                  onTap: () {
                    print("here");
                    // go to a screen that shows all of the details of that order
                    Get.toNamed("/order-detail", arguments: {"order": order});
                  },
                  child: OrderListItem(order: order));
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                width: double.maxFinite,
                height: 3,
                child: Container(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              );
            },
            itemCount: controller.orders.length),
      );
    });
  }
}

class OrderListItem extends StatelessWidget {
  final Order order;

  const OrderListItem({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size.width;
    var statuses = [null, "Pending", "Shipped", "Delivered"];

    var width;
    var maxwidth = 600.01;
    if (screen > maxwidth) {
      width = maxwidth;
    } else {
      width = screen;
    }
    // print("screen: $screen, maxw: $maxwidth, width: $width");
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(),
      width: width,
      child: Card(
        color: Theme.of(context).colorScheme.secondary,
        margin: EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Order Number: ${order.orderNumber}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
              SizedBox(height: 8),
              Wrap(
                children: [
                  Text(
                    'Status: ${statuses[order.status]}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Order Date: ${order.orderDate}',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              ),
              SizedBox(height: 8),
              Text(
                'Total Items: ${order.items.length}',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              ),
              SizedBox(height: 8),
              Text(
                'Total Amount: ${order.paymentInfo.amount} ${order.paymentInfo.currency}',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDetailScreen extends StatelessWidget {
  OrderDetailScreen({super.key});

  Order? order = Get.arguments["order"];
  var statuses = [null, "Pending", "Shipped", "Delivered"];

/*
"shippingAddress": {
        "addressId": 1,
        "street": "hdbdndndj",
        "city": "addis",
        "state": "addis",
        "country": "ethipia",
        "postalCode": "56498"
      }, */
  @override
  Widget build(BuildContext context) {
    if (order == null) {
      return Center(
        child: Text("Order Not Found"),
      );
    } else {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Container(
              decoration: BoxDecoration(),
              clipBehavior: Clip.hardEdge,
              child: Text("Order: ${order!.orderNumber}")),
          leading: backButton(),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: 600,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // general
                  Text(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                      "Order Number: ${order!.orderNumber}"),
                  Text(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                      "Order Status: ${statuses[order!.status]}"),
                  SizedBox(
                    height: 20,
                  ),

                  // shipping
                  Text(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                      "Shipping Address"),
                  SizedBox(
                    height: 10,
                  ),
                  order!.shippingAddress != null
                      ? Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              // border: Border.all(color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.3)),
                              color: Theme.of(context).colorScheme.secondary),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                  "Street: ${order!.shippingAddress!["street"] ?? "N/A"}"),
                              Text(
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                  "city: ${order!.shippingAddress!["city"] ?? "N/A"}"),
                              Text(
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                  "state: ${order!.shippingAddress!["state"] ?? "N/A"}"),
                              Text(
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                  "Country: ${order!.shippingAddress!["Country"] ?? "N/A"}"),
                              Text(
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                  "Postal Code: ${order!.shippingAddress!["postalCode"] ?? "N/A"}"),
                            ],
                          ),
                        )
                      : Text("No Shipping"),
                  SizedBox(
                    height: 20,
                  ),

                  // payment
                  Text(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                      "Payment Information"),
                  SizedBox(
                    height: 10,
                  ),

                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        // border: Border.all(color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.3)),
                        color: Theme.of(context).colorScheme.secondary),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                            "Amount: ${order!.paymentInfo.amount}"),
                        Text(
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                            "Currency: ${order!.paymentInfo.currency}"),
                        Text(
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                            "txRef: ${order!.paymentInfo.txRef}"),
                        Text(
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                            "CreatedAt: ${order!.paymentInfo.createdAt}"),
                        Text(
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                            "UpdatedAt: ${order!.paymentInfo.updatedAt}"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                      "Items"),
                  SizedBox(
                    height: 10,
                  ),

                  ...order!.items
                      .map((e) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              // border: Border.all(color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.3)),
                              color: Theme.of(context).colorScheme.secondary),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                  "ID: ${e.orderItemId}"),
                              Text(
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                  "Price: ${e.price}"),
                              Text(
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                  "Product: ${e.product?["name"] ?? "Unknown"}")
                            ],
                          ),
                        );
                      })
                      .toList()
                      .cast<Widget>(),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
