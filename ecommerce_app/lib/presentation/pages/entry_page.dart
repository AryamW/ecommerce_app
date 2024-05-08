import 'package:ecommerce_app/presentation/controllers/settings_controller.dart';
import 'package:ecommerce_app/presentation/pages/home/components/body.dart';
import 'package:ecommerce_app/presentation/pages/settings/body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/nav_controller.dart';
import '../widgets/navbar.dart';
import '../widgets/navrail.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Initialize the NavigationController
//     return MyNavigationRail();
//   }
// }

class EntryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(NavigationController());
    Get.put(SettingsController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 550) {
          return Obx(
            () => SafeArea(
              child: Column(children: [
                Expanded(
                  child: Get.find<NavigationController>().pages[
                      Get.find<NavigationController>().selectedIndex.value],
                ),
                SafeNavBar(),
              ]),
            ),
          );
        } else {
          return Obx(
            () => SafeArea(
              child: Row(
                children: [
                  SafeNavRail(),
                  Expanded(
                    child: Get.find<NavigationController>().pages[
                        Get.find<NavigationController>().selectedIndex.value],
                  ),
                ],
              ),
            ),
          );
        }
      }),
      // bottomNavigationBar:
    );
  }
}



// class NavigationController extends GetxController {
//   RxInt selectedIndex = 0.obs;
//   List<Widget> pages = [
//     Body(),
//     SettingsBody(),
//   ];

//   void onItemTapped(int index) {
//     selectedIndex.value = index;
//   }
// }
