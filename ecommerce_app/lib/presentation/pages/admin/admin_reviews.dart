import 'package:ecommerce_app/domain/entities/order.dart';
import 'package:ecommerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/presentation/controllers/admin_user.dart';
import 'package:ecommerce_app/presentation/pages/admin/dashboard.dart';
import 'package:ecommerce_app/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/presentation/controllers/admin_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminReviews extends StatelessWidget {
  var controller = Get.find<AdminUsersController>();

  AdminReviews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: backButton(),
        title: Text(
          "Reviews",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: Center(
          child:
              Obx(() => AllReviews(reviews: controller.recentReviews.value))),
    );
  }
}

class AllReviews extends StatelessWidget {
  final List<ReviewModel> reviews;

  AllReviews({super.key, required this.reviews});
  var controller = Get.find<AdminUsersController>();
  @override
  Widget build(BuildContext context) {
    if (reviews.length == 0) {
      if (controller.recentReviewsError.isNotEmpty) {
        return Text(
          "${controller.recentReviewsError['status']}: ${controller.recentReviewsError['message']}",
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        );
      } else {
        return Text("No review to show.",
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary));
      }
    }

    return SingleChildScrollView(
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          ...reviews.map(
            (e) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.secondary,
              ),
              padding: EdgeInsets.all(16),
              width: 400,
              child: reviewWidget(
                review: e,
              ),
            ),
          )
        ],
      ),
    );
  }
}
