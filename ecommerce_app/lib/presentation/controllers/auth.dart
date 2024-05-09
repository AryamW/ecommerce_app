import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/utils/exceptions.dart';
import 'package:ecommerce_app/data/datasources/api_client.dart';
import 'package:ecommerce_app/data/datasources/auth.dart';
import 'package:ecommerce_app/data/repositories/auth.dart';
import 'package:ecommerce_app/domain/entities/auth.dart';
import 'package:ecommerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/domain/repositories/auth.dart';
import 'package:ecommerce_app/domain/usecases/auth.dart';
import 'package:ecommerce_app/presentation/pages/auth/register.dart';
import 'package:ecommerce_app/presentation/widgets/roleBasedAccessControlWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

// to be moved to product controller file.offAllNamed("/register", arguments: {"message": e.toString()});
/*
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
              arguments: {"message": "Something went wrong p"});
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
        Get.snackbar(isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                colorText: ThemeData.dark().colorScheme.onPrimary,"NotFound", "Product is not found.");
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
        Get.snackbar(isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                colorText: ThemeData.dark().colorScheme.onPrimary,"Unauthorised", e.toString());
      }
      return false;
    }
  }
}
*/
class LoginController extends GetxController {
  DioClient dio = DioClient();
  final email = "".obs;
  final password = "".obs;
  RxnString emailError = RxnString(null);
  RxnString passwordError = RxnString(null);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void validateEmail() {
    if (!GetUtils.isEmail(emailController.text)) {
      emailError.value = "Email is not valid";
    } else {
      emailError.value = null;
    }
  }

  void validatePassword() {
    if (passwordController.text.length < 6) {
      passwordError.value = "Password must be at least 6 characters";
    } else {
      passwordError.value = null;
    }
  }

  void submitForm() async {
    validateEmail();
    validatePassword();
    try {
      if (emailError.value == null && passwordError.value == null) {
        var use = AuthUserCase(
            repo: AuthRepositoryImpl(authProvider: AuthDataSource()));
        var data = LoginModel(
            email: emailController.text, password: passwordController.text);
        var res = await use.login(data);
        if (res == true) {
          print(res);
          print(await dio.getRole());
          if (await dio.getRole() == 'Admin') {
            Get.toNamed("/home", arguments: {'role': 'Admin'});
          } else {
            Get.toNamed("/home", arguments: {'role': 'Customer'});
          }
        } else {
          null;
        }
        emailController.text = '';
        passwordController.text = '';
        Core core = Core();
        core.setUserData();
      }
    } on AuthException catch (e) {
      // redendant with badresopnseexcepitonoi to be removed after verification.
      Get.offAllNamed("/login", arguments: {"message": e.toString()});
    } on NetworkException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } on CustomeException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } on BadResponseException catch (e) {
      if (e.statusCode == 500) {
        Get.toNamed("/error", arguments: {"message": e.toString()});
      } else {
        Get.offAllNamed("/login", arguments: {"message": e.message});
      }
    } catch (e) {
      Get.toNamed("/error", arguments: {"message": "Something went wrong"});
    }
  }

  updateEmail(String Email) {
    email(Email);
  }

  updatePassword(String Password) {
    password(Password);
  }
}

class RegisterConroller extends LoginController {
  final firstName = "".obs;
  final lastName = "".obs;
  final confirmPass = "".obs;

  RxnString firstNameError = RxnString(null);
  RxnString lastNameError = RxnString(null);
  RxnString confirmError = RxnString(null);

  void validateFirstName() {
    
      firstNameError.value = null;
  
  }

  void validateLastName() {
   
   
      lastNameError.value = null;
    
  }

  void validateConfirm() {
    if (confirmController.text != passwordController.text) {
      confirmError.value = "Cofirm Password and Password must be similar";
    } else {
      confirmError.value = null;
    }
  }

  void submitForm() async {
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
        var use = AuthUserCase(
            repo: AuthRepositoryImpl(authProvider: AuthDataSource()));
        var res = await use.register(RegisterModel(
            email: emailController.text,
            password: passwordController.text,
            firstname: firstNameController.text,
            lastname: lastNameController.text,
            confirmPassword: confirmController.text));
        res == true
            ? (
                Get.toNamed("/confirm"),
                Future.delayed(
                    Duration(seconds: 2), () => Get.offAllNamed("/login"))
              )
            : Get.toNamed("/login");
        emailController.text = '';
        passwordController.text = '';
        firstNameController.text = '';
        lastNameController.text = '';
        confirmController.text = '';
      }
    } on AuthException catch (e) {
      // redendant with badresopnseexcepitonoi to be removed after verification.
      Get.offAllNamed("/register", arguments: {"message": e.toString()});
    } on NetworkException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } on CustomeException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } on BadResponseException catch (e) {
      if (e.statusCode == 500) {
        Get.toNamed("/error", arguments: {"message": e.toString()});
      } else {
        Get.offAllNamed("/register", arguments: {"message": e.message});
      }
    } catch (e) {
      Get.toNamed("/error", arguments: {"message": "Something went wrong"});
    }
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
}

class LogoutController extends GetxController {
  Future<void> logout() async {
    try {
      var use = AuthUserCase(
          repo: AuthRepositoryImpl(authProvider: AuthDataSource()));
      bool a = await use.logout();
      if (a == true) {
        Get.offAllNamed("/login");
        Get.deleteAll();
        DioClient().getRefreshToken().then(
              (value) => print(" teh role : $value"),
            );

        Core core = Core();
        core.setUserData();
        print(core.role);
      }
    } catch (e) {
      Get.snackbar(
          isDismissible: true,
          duration: Duration(seconds: 10),
          backgroundColor: ThemeData.dark().colorScheme.secondary,
          colorText: ThemeData.dark().colorScheme.onPrimary,
          "Logout Failed.",
          "log out failed. try again.");
    }
  }
}

class ForgotPasswordController extends GetxController {
  /*
  final email = "".obs;
  final password = "".obs;
  RxnString emailError = RxnString(null);
  RxnString passwordError = RxnString(null);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
   */
  final email = "".obs;
  final emailController = TextEditingController();

  final token = "".obs;
  RxnString emailError = RxnString(null);
  RxnString passwordError = RxnString(null);

  RxnString confirmPasswordError = RxnString(null);
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  String changeEmail(String value) {
    email.value = value;
    return email.value;
  }

  String changeToken(String value) {
    token.value = value;
    return token.value;
  }

  var use =
      AuthUserCase(repo: AuthRepositoryImpl(authProvider: AuthDataSource()));
  void validateEmail(value) {
    if (!GetUtils.isEmail(value)) {
      emailError.value = "Email is not valid";
    } else {
      emailError.value = null;
    }
  }

  void validateConfirm() {
    if (confirmNewPasswordController.text != newPasswordController.text) {
      confirmPasswordError.value =
          "Cofirm Password and Password must be similar";
    } else {
      confirmPasswordError.value = null;
    }
  }

  void validatePassword() {
    if (newPasswordController.text.length < 6) {
      passwordError.value = "Password must be at least 6 characters";
    } else {
      passwordError.value = null;
    }
  }

  void initiate() async {
    validateEmail(emailController.text);
    try {
      if (emailError.value == null) {
        var res = await use.forgotPasswordEmail(emailController.text);
        if (res == true) {
          emailController.text = '';
          Get.toNamed("/confirm", arguments: {"sent": true});
        }
      }
    } on AuthException catch (e) {
      // redendant with badresopnseexcepitonoi to be removed after verification.

      Get.offAllNamed("/login", arguments: {"message": e.toString()});
    } on NetworkException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } on CustomeException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } on BadResponseException catch (e) {
      if (e.statusCode == 500) {
        Get.toNamed("/error", arguments: {
          "message": e.toString(),
        });
      } else {
        Get.offAllNamed("/login", arguments: {"message": e.message});
      }
    } catch (e) {
      Get.toNamed("/error", arguments: {"message": "Something went wrong"});
    }

    emailController.text = '';
  }

  void submit() async {
    print("ere?");
    print(
        'email: ${email.value}, token: ${token.value}, pass: ${newPasswordController.text}, con: ${confirmNewPasswordController.text}');
    validateEmail(email.value);
    validatePassword();
    validateConfirm();
    try {
      if (emailError.value == null &&
          passwordError.value == null &&
          confirmPasswordError.value == null) {
        var data = {
          "email": email.value,
          "resetToken": token.value,
          "password": newPasswordController.text,
          "confirmPassword": confirmNewPasswordController.text
        };

        var res = await use.forgotPasswordNew(data);
        if (res == true) {
          Get.snackbar(
              isDismissible: true,
              duration: Duration(seconds: 10),
              backgroundColor: ThemeData.dark().colorScheme.secondary,
              colorText: ThemeData.dark().colorScheme.onPrimary,
              "Success",
              "Your Request has been sent. Please wait a few minutes.");
        }

        email.value = '';
        newPasswordController.text = '';
        confirmNewPasswordController.text = "";
        token.value = "";
      }
    } on AuthException catch (e) {
      // redendant with badresopnseexcepitonoi to be removed after verification.
      Get.offAllNamed("/login", arguments: {"message": e.toString()});
    } on NetworkException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } on CustomeException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } on BadResponseException catch (e) {
      if (e.statusCode == 500) {
        Get.toNamed("/error", arguments: {
          "message": e.toString(),
        });
      } else {
        Get.offAllNamed("/login", arguments: {"message": e.message});
      }
    } catch (e) {
      Get.toNamed("/error", arguments: {"message": "Something went wrong"});
    }
  }
}
