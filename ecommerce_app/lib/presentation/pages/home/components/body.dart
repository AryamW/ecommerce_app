import 'package:ecommerce_app/core/utils/roles.dart';
import 'package:ecommerce_app/main.dart';
import 'package:ecommerce_app/presentation/controllers/home_page_controller.dart';
import 'package:ecommerce_app/presentation/controllers/nav_controller.dart';
import 'package:ecommerce_app/presentation/pages/home/components/home_result.dart';
import 'package:ecommerce_app/presentation/widgets/roleBasedAccessControlWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'categories.dart';
import 'searching_bar.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {Get.find<NavigationController>().onItemTapped(1);},
                  //  onPressed: () => Get.toNamed("/settings"),
                  icon: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.onPrimary,
                  )),
              SearchingBar(),
              IconButton(
                onPressed: () {
                  Get.find<ThemeController>().onItemTapped();
                },
                icon: Icon(Icons.dark_mode_outlined),
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              AccessControlWidget(
                allowedRole: Roles.CUSTOMER,
                showError: false,
                child: IconButton(
                  onPressed: () {
                    Get.toNamed("/cart");
                  },
                  // => Get.toNamed("/checkout"),
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ProductListScreen())),
                  icon: Icon(Icons.shopping_bag_outlined),
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              AccessControlWidget(
                allowedRole: Roles.CUSTOMER,
                showError: false,
                child: IconButton(
                  onPressed: () {
                    print("here?");
                    Get.toNamed("/orders");
                
                
                  },
                  icon: Icon(Icons.history),
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        // Categories(),
        Obx(()=> AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          height: Get.find<HomePageController>().isExpanded.value? 155 : 0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Categories(),
          ),
                ),
        ),
        Obx(() => Center(
              child: IconButton(icon: Get.find<HomePageController>().isExpanded.value? Icon(Icons.arrow_drop_up_outlined,color: Theme.of(context).colorScheme.onPrimary,) : Icon(Icons.arrow_drop_down_outlined, color: Theme.of(context).colorScheme.onPrimary,),
            onPressed: () {
              Get.find<HomePageController>().changeExpansion();
              },)),
            ),
        Expanded(child: HomeResult()),
      ],
    );
  }
}
