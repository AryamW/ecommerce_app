import 'package:ecommerce_app/core/utils/roles.dart';
import 'package:ecommerce_app/data/datasources/admin_user.dart';
import 'package:ecommerce_app/domain/entities/order.dart';
import 'package:ecommerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/presentation/controllers/admin_user.dart';
import 'package:ecommerce_app/presentation/widgets/button.dart';
import 'package:ecommerce_app/presentation/widgets/roleBasedAccessControlWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AdminDashBoard extends StatelessWidget {
  AdminDashBoard({super.key});
  var controller = Get.find<AdminUsersController>();

  @override
  Widget build(BuildContext context) {
    return AccessControlWidget(
      allowedRole: Roles.ADMIN,
      child: Material(
          color: Theme.of(context).colorScheme.primary,
          child: DashBoard(controller: controller)),
    );
  }
}

class DashBoard extends StatelessWidget {
  final AdminUsersController controller;
  DashBoard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    controller.fetchRecentOrders();
    controller.fetchRecentReviews();
    return Container(
      padding: EdgeInsets.all(40),
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 10,
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.start,
        children: [
          Container(
            width: 350,
            child: Card(
              color: Theme.of(context).colorScheme.secondary,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        runAlignment: WrapAlignment.spaceBetween,
                        children: [
                          Text(
                            "Recent Reviews",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed("/admin-recent-reviews");
                            },
                            child: Text(
                              "View All",
                              style: TextStyle(color: Colors.orange),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Obx(() {
                      if (controller.recentReviews.value.isEmpty &&
                          controller.recentReviewsError.isEmpty) {
                        return Center(
                          child: Text("No reviews.",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary)),
                        );
                      } else if (controller.recentReviewsError.isNotEmpty) {
                        return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ErrCode: ${controller.recentReviewsError['status']}",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary)),
                            SizedBox(
                              height: 4,
                            ),
                            Text(controller.recentReviewsError['message'],
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary)),
                          ],
                        );
                      } else {
                        return reviewWidget(
                            review: controller.recentReviews.value[0]);
                      }
                    })
                  ],
                ),
              ),
            ),
          ),

          Container(
            width: 350,
            child: Card(
              color: Theme.of(context).colorScheme.secondary,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        runAlignment: WrapAlignment.spaceBetween,
                        children: [
                          Text(
                            "Recent Orders",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed("/admin-recent-orders");
                            },
                            child: Text(
                              "View All",
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(() {
                      if (controller.recentOrders.value.isEmpty &&
                          controller.recentOrdersError.isEmpty) {
                        return Center(
                          child: Text("No Orders.",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary)),
                        );
                      } else if (controller.recentOrdersError.isNotEmpty) {
                        // return Text(controller.recentOrdersError.toString(), style: TextStyle(color: Theme.of(context).colorScheme.onSecondary));
                        return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text("ErrCode: ${controller.recentOrdersError['status']}",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary)),
                            SizedBox(
                              height: 4,
                            ),
                            Text(controller.recentOrdersError['message'],
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary)),
                          ],
                        );
                      } else {
                        return ordersWidget(
                          count: controller.monthlyOrder.value,
                          order: controller.recentOrders.value[0],
                        );
                      }
                    })
                  ],
                ),
              ),
            ),
          ),

          // Obx(() => ordersWidget(
          //     count: controller.monthlyOrder.value,
          //     order: controller.recentOrders.value.isEmpty
          //         ? null
          //         : controller.recentOrders.value[0]))
        ],
      ),
    );
  }
}

class ordersWidget extends StatelessWidget {
  final int count;
  final Order order;
  const ordersWidget({
    super.key,
    required this.count,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              "$count",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 36,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "\tOrder${count > 1 ? "s" : ""} in this Month",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 12),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${order.user?.firstname ?? "Unknown"}",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Wrap(
                    children: [
                      Wrap(
                        children: [
                          Text(
                            "Order Number: ",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            order.orderNumber,
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary),
                          ),
                        ],
                      ),
                      Text(
                        "Amount: ${order!.paymentInfo.amount}",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class reviewWidget extends StatelessWidget {
  final ReviewModel review;
  const reviewWidget({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        direction: Axis.vertical,
        children: [
          Row(
            children: [
              CircleAvatar(
                child: Icon(Icons.person),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 190,
                    child: Text(
                      "${review.name}",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          overflow: TextOverflow.clip),
                    ),
                  ),
                  Row(
                      children: [1, 2, 3, 4, 5].map(
                    (e) {
                      var color = Theme.of(context).colorScheme.onSecondary;
                      var icon = Icons.star_border;
                      if (e <= review.rating) {
                        icon = Icons.star;
                        color = Colors.yellow;
                      }
                      return Icon(icon, color: color);
                    },
                  ).toList()),
                ],
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            review.review,
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          )
        ],
      ),
    );
  }
}




/*
var children = [
      Container(
        width: 200,
        height: 300,
        color: Colors.red,
      ),
      Container(
        width: 300,
        height: 200,
        color: Colors.red,
      ),
      Container(
        width: 200,
        height: 300,
        color: Colors.red,
      ),
      Container(
        width: 400,
        height: 100,
        color: Colors.red,
      ),
      Container(
        width: 200,
        height: 300,
        color: Colors.red,
      ),
      Container(
        width: 140,
        height: 500,
        color: Colors.red,
      ),
      Container(
        width: 200,
        height: 300,
        color: Colors.red,
      ),
      Container(
        width: 200,
        height: 300,
        color: Colors.red,
      ),
    ];
 */