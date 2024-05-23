import 'package:ecommerce_app/core/utils/exceptions.dart';
import 'package:ecommerce_app/data/datasources/cart.dart';
import 'package:ecommerce_app/data/repositories/cart.dart';
import 'package:ecommerce_app/domain/entities/cart.dart';
import 'package:ecommerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/domain/usecases/cart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

class CartController extends GetxController {
  final cart =
      CartModel(success: false, message: "failed. not found", data: null).obs;

  var useCase =
      CartUseCase(repo: CartRepositoryImp(cartDataSource: CartDataSource()));

  void changeCart(CartModel value) {
    cart(value);
  }

  void addToCart(Map<String, dynamic> product) async {
    try {
      await useCase.addToCart(product);
      Get.snackbar(
          isDismissible: true,
          duration: Duration(seconds: 10),
          backgroundColor: ThemeData.dark().colorScheme.secondary,
          colorText: ThemeData.dark().colorScheme.onPrimary,
          "Success",
          "Product Added to cart successfully.");
    } on CustomeException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } on BadResponseException catch (e) {
      Get.snackbar(
          isDismissible: true,
          duration: Duration(seconds: 10),
          backgroundColor: ThemeData.dark().colorScheme.secondary,
          colorText: ThemeData.dark().colorScheme.onPrimary,
          "Failed",
          "Failed to add to Cart. please try again later.");
      // somethings/
    } on NetworkException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } catch (e) {
      Get.toNamed("/error", arguments: {
        "message": "Unexpected Error has occured!. please try again later."
      });
    }
  }

  Future<CartModel?> fetchItems() async {
    try {
      var cartv2 = await useCase.fetchItems();
      changeCart(cartv2!);
      print(cartv2.data!.items[0].product.images);
      return cart.value;
    } on BadResponseException catch (e) {
      rethrow;
    } on NetworkException catch (e) {
      rethrow;
    } on CustomeException catch (e) {
      rethrow;
    } catch (e) {
      
      throw Exception("Something went wrong. Try again later.");
    }
  }

  Future<void> updateItem(Map<String, int> json) async {
    try {
      var valid = await useCase.updateCartItem(json);
      if (valid == true) {
        var item = await useCase.fetchItems();

        changeCart(item!);
      }
    } on BadResponseException catch (e) {
      if (e.statusCode == 404) {
        Get.toNamed("/emptyCart");
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

  Future<void> deleteItem(Map<String, int> json) async {
    try {
      var valid = await useCase.removeFromCart(json);
      if (valid == true) {
        var item = await useCase.fetchItems();

        changeCart(item!);
      }
    } on BadResponseException catch (e) {
      if (e.statusCode == 404) {
        Get.toNamed("/emptyCart");
      } else if (e.statusCode == 400) {
        Get.snackbar(
            isDismissible: true,
            duration: Duration(seconds: 10),
            backgroundColor: ThemeData.dark().colorScheme.secondary,
            colorText: ThemeData.dark().colorScheme.onPrimary,
            "Invalid",
            "invalid cart item Iid.");
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
}
