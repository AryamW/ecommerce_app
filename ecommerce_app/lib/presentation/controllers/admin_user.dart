import 'package:ecommerce_app/data/datasources/admin_user.dart';
import 'package:ecommerce_app/data/repositories/admin_user.dart';
import 'package:ecommerce_app/domain/entities/auth.dart';
import 'package:ecommerce_app/domain/entities/edit_user.dart';
import 'package:ecommerce_app/core/utils/exceptions.dart';
import 'package:ecommerce_app/core/utils/exceptions.dart';
import 'package:ecommerce_app/domain/entities/order.dart';
import 'package:ecommerce_app/domain/entities/product.dart';

import 'package:ecommerce_app/domain/usecases/admin_users.dart';
import 'package:ecommerce_app/presentation/controllers/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUsersController extends RegisterConroller {
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
  }

  final queryParam = TextEditingController();
  final Users = Rx<List<GetUserModel>>([]);
  final recentReviews = Rx<List<ReviewModel>>([]);
  final monthlyOrder = 0.obs;
  RxMap recentOrdersError = RxMap({});
  RxMap recentReviewsError = RxMap({});

  final recentOrders = Rx<List<Order>>([]);

  final filterUsers = Rx<List<GetUserModel>>([]);
  final currentPage = 0.obs;
  final rowsPerPage = 10.obs;
  final currentPageUsers = Rx<List<GetUserModel>>([]);

  final mostPopularProducts = Rx<List<Product>>([]);
  final mostPopularProductsError = RxMap({});
  final topProductNumber = 10.obs;

  final outOfStockProducts = Rx<List<Product>>([]);
  final outOfStockProductsError = RxMap({});
  final outOfStockNumber = 0.obs;

  AdminUserUseCase useCase =
      AdminUserUseCase(repo: AdminUserImp(dataSource: AdminUserDataSource()));
  Future<List<GetUserModel>> fetchUsers() async {
    try {
      var res = await useCase.fetchUsers();
      Users(res);
      filterUsers(res);
      filterUsers.refresh();
      changePage(0);
      Users.refresh();
      return Users.value;
    } on BadResponseException catch (e) {
      if (e.statusCode == 404) {
        return Users.value;
      } else if (e.statusCode == 400) {
        Get.snackbar(
            isDismissible: true,
            duration: Duration(seconds: 10),
            backgroundColor: ThemeData.dark().colorScheme.secondary,
            colorText: ThemeData.dark().colorScheme.onPrimary,
            "Invalid",
            "invalid request.");
      } else if (e.statusCode == 500) {
        Get.toNamed("/error", arguments: {
          "message": "A Server Error has occured. try again later."
        });
      }
    } on NetworkException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } on CustomeException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } catch (e) {
      Get.toNamed("/error",
          arguments: {"message": "something went wrong. try again later"});
    }
    return [];
  }

  void changePage(int pageNumber) {
    currentPage(pageNumber);
    filterUsers(Users.value
        .skip(currentPage.value * rowsPerPage.value)
        .take(rowsPerPage.value)
        .toList());
    filterUsers.refresh();
  }

  void changeList(String value) {
    var users = Users.value.where((element) {
      if (element.firstname?.contains(queryParam.text) ?? false) {
        return true;
      } else if (element.lastname?.contains(queryParam.text) ?? false) {
        return true;
      } else if (element.email?.contains(queryParam.text) ?? false) {
        return true;
      }
      return false;
    });
    filterUsers(users.toList());
    filterUsers.refresh();
  }

  void deleteUser(String id, String email) async {
    try {
      var res = await useCase.deleteUser(id, email);
      if (res) {
        await fetchUsers();
        Users.refresh();
      }
    } on BadResponseException catch (e) {
      if (e.statusCode == 404) {
        Get.snackbar(
            isDismissible: true,
            duration: Duration(seconds: 10),
            backgroundColor: ThemeData.dark().colorScheme.secondary,
            colorText: ThemeData.dark().colorScheme.onPrimary,
            "Failed",
            "User Doesn't exist");
      } else if (e.statusCode == 400) {
        Get.snackbar(
            isDismissible: true,
            duration: Duration(seconds: 10),
            backgroundColor: ThemeData.dark().colorScheme.secondary,
            colorText: ThemeData.dark().colorScheme.onPrimary,
            "Invalid",
            "invalid request.");
      } else if (e.statusCode == 500) {
        Get.toNamed("/error", arguments: {
          "message": "A Server Error has occured. try again later."
        });
      }
    } on NetworkException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } on CustomeException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } catch (e) {
      Get.toNamed("/error",
          arguments: {"message": "something went wrong. try again later"});
    }
  }

  @override
  void submitForm() async {
    print("ere?");
    validateEmail();
    validatePassword();
    validateFirstName();
    validateLastName();
    validateConfirm();

    try {
      if (emailError.value == null &&
          passwordError.value == null &&
          firstNameError.value == null &&
          lastNameError.value == null &&
          confirmError.value == null) {
        var use = AdminUserUseCase(
            repo: AdminUserImp(dataSource: AdminUserDataSource()));
        var res = await use.register(RegisterModel(
            email: emailController.text,
            password: passwordController.text,
            firstname: firstNameController.text,
            lastname: lastNameController.text,
            confirmPassword: confirmController.text));
        if (res == true) {
          (
            Get.toNamed("/confirm"),
            Future.delayed(Duration(seconds: 2), () => Get.back())
          );
          await fetchUsers();
        }

        emailController.text = '';
        passwordController.text = '';
        firstNameController.text = '';
        lastNameController.text = '';
        confirmController.text = '';
      }
    } on AuthException catch (e) {
      // redendant with badresopnseexcepitonoi to be removed after verification.
      Get.back();
    } on NetworkException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } on CustomeException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } on BadResponseException catch (e) {
      if (e.statusCode == 500) {
        Get.toNamed("/error", arguments: {"message": e.toString()});
      } else {
        Get.back();
      }
    } catch (e) {
      Get.toNamed("/error", arguments: {"message": "Something went wrong"});
    }
  }

  Future<List<ReviewModel>> fetchRecentReviews() async {
    recentReviewsError(null);

    try {
      var res = await useCase.fetchRecentReviews();
      recentReviews(res);
    } on BadResponseException catch (e) {
      recentReviewsError({"status": e.statusCode, "message": e.message});
    } on NetworkException catch (e) {
      recentReviewsError({"status": "Network", "message": e.toString()});
    } catch (e) {
      print("errorR: $e");

      recentReviewsError({"status": null, "message": "Unavailable"});
    }
    return [];
  }

  Future<RecentOrders?> fetchRecentOrders() async {
    recentOrdersError(null);
    try {
      var res = await useCase.fetchRecentOrders();
      if (res == null) {
        recentOrders([]);
        recentOrders.refresh();
        monthlyOrder(0);
      }
      recentOrders(res!.orders);
      monthlyOrder(res.count);
    } on BadResponseException catch (e) {
      recentOrdersError({"status": e.statusCode, "message": e.message});
    } on NetworkException catch (e) {
      recentOrdersError({"status": "Network", "message": e.toString()});
    } catch (e) {
      print("errorO: $e");
      recentOrdersError({"status": null, "message": "Unavailable"});
    }
    return null;
  }

  void delivered(int id, int status) async {
    try {
      var res = await useCase.delivered(id, status);
      // recentOrders.refresh();
      if (res == true) {
        // print("the id:$id");
        // var o = recentOrders.value.firstWhere((element) => element.orderId == id);
        // // for (var order in recentOrders.value) {
        // //   print("the id: $id, the pID: ${order.orderId}");
        // //   if (order.orderId == id) {
        // //   }
        // // }
        //     o.status = status;
        // recentOrders.refresh();
        await fetchRecentOrders();
      }
    } on BadResponseException catch (e) {
      if (e.statusCode == 404) {
        Get.snackbar(
            isDismissible: true,
            duration: const Duration(seconds: 10),
            backgroundColor: ThemeData.dark().colorScheme.secondary,
            colorText: ThemeData.dark().colorScheme.onPrimary,
            "Not Exist",
            "The Order doesn't exist");
      } else if (e.statusCode == 400) {
        Get.snackbar(
            isDismissible: true,
            duration: const Duration(seconds: 10),
            backgroundColor: ThemeData.dark().colorScheme.secondary,
            colorText: ThemeData.dark().colorScheme.onPrimary,
            "Invalid",
            "invalid request.");
      } else if (e.statusCode == 500) {
        Get.toNamed("/error", arguments: {
          "message": "A Server Error has occured. try again later."
        });
      } else if (e.statusCode == 403) {
        Get.toNamed("/error",
            arguments: {"message": "Something went wrong. ${e.toString()}"});
      } else {
        Get.toNamed("/error",
            arguments: {"message": "Something went wrong. ${e.toString()}"});
      }
    } on NetworkException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } on CustomeException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } catch (e) {
      Get.toNamed("/error",
          arguments: {"message": "something went wrong. try again later"});
    }
  }

  Future<List<PDetailModel?>> fetchMostPopularProducts() async {
    try {
      var res = await useCase.fetchMostPopularProducts();
      mostPopularProducts(res);
    } on BadResponseException catch (e) {
      mostPopularProductsError({"status": e.statusCode, "message": e.message});
    } on NetworkException catch (e) {
      mostPopularProductsError({"status": "Network", "message": e.toString()});
    } catch (e) {
      print("errorR: $e");

      mostPopularProductsError({"status": null, "message": "Unavailable"});
    }
    return [];
  }
}
