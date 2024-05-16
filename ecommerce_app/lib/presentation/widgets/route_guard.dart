import 'package:ecommerce_app/core/routes/routes.dart';
import 'package:ecommerce_app/presentation/widgets/roleBasedAccessControlWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RouteGuard extends GetxController {
  RxBool isAuthenticated = false.obs;
  Core core = Core();
  void toggleLoginStatus(bool stat) {
    if (stat) {
      isAuthenticated.value = true;
    } else {
      isAuthenticated.value = false;
    }
    // print("stat == $stat");
    update();
  }
}

class RouteGuardMiddelware extends GetMiddleware {
  @override
  int? priority = 0;

  RouteGuardMiddelware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    String routeTry;
    if (route != null) {
      routeTry = Uri.parse(route).path;
    } else {
      routeTry ="";
    }
    print("middleware${Get.find<RouteGuard>().isAuthenticated.isTrue}");
    // print("route is $route");
    if (Get.find<RouteGuard>().isAuthenticated.isTrue &&
        loginRoutes.contains(routeTry)) {
      // print("route is loginRoute, redirecting.......");
      return const RouteSettings(name: "/home");
    } else if (Get.find<RouteGuard>().isAuthenticated.isTrue &&
        !loginRoutes.contains(routeTry) &&
        !homeRoutes.contains(routeTry)) {
      // print("route is loginRoute, redirecting.......");
      return const RouteSettings(name: "/home");
    } else if (Get.find<RouteGuard>().isAuthenticated.isFalse &&
        homeRoutes.contains(routeTry)) {
      // print("route is homeRoute, redirecting.......");
      return const RouteSettings(name: "/login");
    } else if (Get.find<RouteGuard>().isAuthenticated.isFalse &&
        !loginRoutes.contains(routeTry) &&
        !homeRoutes.contains(routeTry)) {
      // print("route is loginRoute, redirecting.......");
      return const RouteSettings(name: "/login");
    }
    return null;
  }
}
