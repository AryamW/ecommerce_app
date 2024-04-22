import 'package:ecommerce_app/core/utils/exceptions.dart';
import 'package:ecommerce_app/data/datasources/checkout.dart';
import 'package:ecommerce_app/data/repositories/checkout.dart';
import 'package:ecommerce_app/domain/entities/cart.dart';
import 'package:ecommerce_app/domain/entities/checkout.dart';
import 'package:ecommerce_app/domain/usecases/checkout.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CheckoutController extends GetxController {
  final txref = RxnString(null);
  final checkoutUrl = RxnString(null);
  final shippingAddress = RxnInt(null);
  final orderNumber = RxnString(null);
  final RxList<Map<String, dynamic>> shippingAddressChoices = RxList();

  var useCase = checkoutUseCase(
      repo: CheckoutRepositoryImp(checkoutDataSource: CheckoutDataSource()));

  void launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrlString(url);
    } else {
      throw CustomeException(
          message: "The Url Can not be launched. Please Try again later.");
    }
  }

  void makePayment() async {
    // var body = {"currency": "ETB", "returnUrl": "www.google.com"};
    print("make Payment");

    try {
      var res = await useCase.makePayment(CheckoutModel(
          currency: "ETB",
          returnUrl:
              "https://red-ecommerce.onrender.com/test/redirect?path=add-checkout"));

      txref(res?.txref);
      checkoutUrl(res?.checkoutUrl);
      await fetchAddress();
      print(checkoutUrl.value);
      launchUrlString(checkoutUrl.value!);
    } on BadResponseException catch (e) {
      if (e.statusCode == 400) {
        Get.snackbar("Invalid", "Product out of Stock");
      } else if (e.statusCode == 500) {
        print("heres?");
        Get.toNamed("/error", arguments: {
          "message": "A Server Error has occured. try again later."
        });
      }
    } on NetworkException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } on CustomeException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } catch (e) {
      print("es: $e");
      Get.toNamed("/error",
          arguments: {"message": "something went wrong. try again later"});
    }
  }

  Future<void> fetchAddress() async {
    print("fetch Address");
    try {
      var res = await useCase.fetchAddresses();
      shippingAddressChoices(res);

      shippingAddressChoices.refresh();
    } on BadResponseException catch (e) {
      if (e.statusCode == 404) {
        Get.toNamed("/error", arguments: {
          "message": "Addresses Not Provided.",
          "backDest": "/cart"
        });
      } else if (e.statusCode == 400) {
        Get.snackbar("Invalid", "invalid request.");
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
      print("es2: $e");

      Get.toNamed("/error",
          arguments: {"message": "something went wrong. try again later"});
    }
  }

  void verify() async {
    try {
      var res = await useCase.verify(
          {"txRef": txref.value!, "shippingAddressId": shippingAddress.value!});
      if (res != null && res.isNotEmpty) {
        print("verified");
        orderNumber(res["data"]["orderNumber"]);
        print(orderNumber.value);
        print("kljakljf:${res["data"]["orderNumber"].runtimeType}");
        Get.toNamed("/checkout");
      }
    } on BadResponseException catch (e) {
      if (e.statusCode == 400) {
        Get.snackbar("Invalid", "invalid request.");
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
      print("es3: $e");

      Get.toNamed("/error",
          arguments: {"message": "something went wrong. try again later"});
    }
  }
}
