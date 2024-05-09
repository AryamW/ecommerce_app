import 'package:ecommerce_app/core/utils/exceptions.dart';
import 'package:ecommerce_app/data/datasources/auth.dart';
import 'package:ecommerce_app/data/repositories/auth.dart';
import 'package:ecommerce_app/domain/usecases/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/product.dart';


// to be moved to product controller file.offAllNamed("/register", arguments: {"message": e.toString()});
class PDetailController extends GetxController {
  final rating = RxnInt(null);
  TextEditingController reviewController = TextEditingController();
  RxBool valid = false.obs;
  void changeRating(value) {
    rating(value);
  }

  void validateReview() {
    if (rating.value != null && reviewController.text.isNotEmpty) {
      valid.value = true;
    } else {
      valid.value = false;
    }
    ;
  }

  void submitForm(int pid) async {
    validateReview();
    if (valid.value == true) {
      try {
        var use = ReviewUseCase(
            repo: ReviewRepositoryImp(reviewSource: ReviewDataSource()));
        var res = await use.send(
            ReviewModel(
                review: reviewController.text,
                rating: rating.value!,
                isMine: true),
            pid);
        Get.offAndToNamed("/productDetail", arguments: {"id": pid});

        changeRating(0);
        reviewController.text = "";
      } on CustomeException catch (e) {
        Get.offAllNamed("/error", arguments: {"message": e.toString()});
      } on BadResponseException catch (e) {
        if (e.statusCode == 500) {
          Get.toNamed("/error", arguments: {
            "message":
                "An error has Occured on the server side. please try later."
          });
        } else if (e.statusCode == 400) {
          Get.toNamed("/error",
              arguments: {"message": "Invalid Request Format."});
        } else {
          Get.toNamed("/error",
              arguments: {"message": "Something went wrong"});
        }
      } on NetworkException catch (e) {
        Get.toNamed("/error", arguments: {
          "message": "Network Error: ${e.toString()}",
          "backDest": "/home"
        });
      } catch (e) {
        Get.toNamed("/error", arguments: {"message": "login is needed"});
        Future.delayed(const Duration(seconds: 2), () => Get.toNamed("/login"));
        // Get.toNamed("/login");
      }
    }
    // submit the reviews using a use case.
  }

  Future<PDetailModel?> retrieveProduct(int id) async {
    PDetailModel? a;
    try {
      var usePd = PDetailUseCase(
          repo: PDetailRepositoryImp(dataSource: PDetailDataSource()));
      a = await usePd.fetch(id);

      var useR = ReviewUseCase(
          repo: ReviewRepositoryImp(reviewSource: ReviewDataSource()));
      var reviews = await useR.fetch(a!.id);
      a.reviews = reviews;
      // removable if image provided from the server.
      if (a.images!.isEmpty) {
        a.images!
            .add("https://red-ecommerce.onrender.com/images/DefaultImage.jpg");
      }
      return a;
    } on CustomeException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } on BadResponseException catch (e) {
      if (e.statusCode == 500) {
        Get.offNamed("/error", arguments: {
          "message":
              "An Error has occured on the server side. please try again later."
        });
      } else if (e.statusCode == 404 && e.path == "/products/$id") {
        Get.offNamed("/home");
        Get.snackbar("NotFound", "Product is not found.");
      } else if (e.path != "/product/$id") {
        return a;
      }
    } on NetworkException catch (e) {
      Get.toNamed("/error",
          arguments: {"messsage": e.toString(), "backDest": "/home"});
    } catch (e) {
      return a;
    }
    return null;
  }

  Future<bool> delete(int pid) async {
    try {
      var useR = ReviewUseCase(
          repo: ReviewRepositoryImp(reviewSource: ReviewDataSource()));
      return await useR.delete(pid);
    } on BadResponseException catch (e) {
      if (e.statusCode == 404) {
        Get.toNamed("/error", arguments: {
          "message": "This review doesn't exist. please refresh your page."
        });
      } else if (e.statusCode == 401 && e.path != '/auth/refresh') {
        Get.snackbar("Unauthorised", e.toString());
      }
      return false;
    }
  }
}