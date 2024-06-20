import 'package:ecommerce_app/core/utils/exceptions.dart';
import 'package:ecommerce_app/data/datasources/edit_user.dart';
import 'package:ecommerce_app/data/datasources/api_client.dart';
import 'package:ecommerce_app/data/repositories/edit_user.dart';
import 'package:ecommerce_app/domain/entities/edit_user.dart';
import 'package:ecommerce_app/domain/usecases/edit_user.dart';
import 'package:ecommerce_app/presentation/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditUserController extends GetxController {
  late GetUserModel? user;
  EditUserController(){
  user = Get.arguments?['user']; 
  if (user!=null){
    firstNameController.text = user!.firstname ?? '';
    lastNameController.text = user!.lastname ?? '';
    emailController.text = user!.email ?? '';
    phoneController.text = user!.phoneNumber ?? '';
    }
  }
  DioClient dio = DioClient();
  final firstName = "".obs;
  final lastName = "".obs;
  final email = "".obs;
  final phone = "".obs;
  final password = "".obs;
  final confirmPass = "".obs;

  var editList = [true,false,false,false].obs;
  var obscure = true.obs;
  
   void changeObscure(){
  obscure.value = !obscure.value;
  }
  void chanageEdit(int index){
    editList[index] = editList[index];
  }
  bool getEdit(int index){
    return editList[index];
  }

  RxnString firstNameError = RxnString(null);
  RxnString lastNameError = RxnString(null);
  RxnString emailError = RxnString(null);
  RxnString phoneError = RxnString(null);
  RxnString passwordError = RxnString(null);
  RxnString confirmError = RxnString(null);


  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();


  void validateFirstName() {
    if (firstNameController.text.length < 6 && firstNameController.text.isNotEmpty) {
      firstNameError.value = "firstname must be at least 6 characters";
    }else if(!firstNameController.text.isAlphabetOnly && firstNameController.text.isNotEmpty){
      firstNameError.value = "firstname must be letters only";
    } else {
      firstNameError.value = null;
    }
  }

  void validateLastName() {
    if (lastNameController.text.length < 6 && lastNameController.text.isNotEmpty) {
      lastNameError.value = "lastname must be at least 6 characters";
    }else if(!lastNameController.text.isAlphabetOnly && lastNameController.text.isNotEmpty){
      lastNameError.value = "lastname must be letters only";
    } else {
      lastNameError.value = null;
    }
  }

  void validateEmail() {
    if (!GetUtils.isEmail(emailController.text) && emailController.text.isNotEmpty) {
      emailError.value = "Email is not valid";
    } else {
      emailError.value = null;
    }
  }

  void validatePhone() {
    if (!phoneController.text.isPhoneNumber && phoneController.text.isNotEmpty) {
      phoneError.value = "Phone number is not valid";
    } else {
      phoneError.value = null;
    }
  }

  void validatePassword() {
    
    if (newPasswordController.text.isNotEmpty) {
      if (oldPasswordController.text.isEmpty) {
        passwordError.value = "Old Password cannot be empty";
      } else if (oldPasswordController.text.length < 6 &&
          oldPasswordController.text.isNotEmpty) {
        passwordError.value = "Old Password must be at least 6 characters";
      } else {
        passwordError.value = null;
      }
    }
  }

  void validatePasswordNotMatch() { 
      validatePassword();
    if (newPasswordController.text == oldPasswordController.text && newPasswordController.text.isNotEmpty) {
      confirmError.value = "Old Password and New Password are the same";
    } else if (newPasswordController.text.length < 6  && newPasswordController.text.isNotEmpty) {
      confirmError.value = "New Password must be at least 6 characters";
    } else {
      confirmError.value = null;
    }
  }
  void validateChange(EditUserModel editedUser) {
    if (user != null) {
      if (firstNameController.text != user!.firstname) {
        editedUser.firstname = firstNameController.text;
      }
      if (lastNameController.text != user!.lastname) {
        editedUser.lastname = lastNameController.text;
      }
      if (emailController.text != user!.email) {
        editedUser.email = emailController.text;
      }
      if (phoneController.text != user!.phoneNumber) {
        editedUser.phone = phoneController.text;
      }
      if(newPasswordController.text.isNotEmpty){
        editedUser.oldPassword = oldPasswordController.text;
        editedUser.newPassword = newPasswordController.text;
      }
    }
  }

  void submitForm() async {
    validateEmail();
    validatePhone();
    validateFirstName();
    validateLastName();
    validatePasswordNotMatch();
    var editedUser = EditUserModel();
    validateChange(editedUser);
    if (editedUser.toJson().toString() == {}.toString()) {
      //something happens
      Get.snackbar("Nothing to change","Please enter the field you want to edit",
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                duration: Duration(seconds: 10), 
                isDismissible: true,
                colorText: ThemeData.dark().colorScheme.onPrimary);
    } else {
      try {
        var use = EditUserCase(
            repo:
                EditUserRepositoryImpl(editUserProvider: EditUserDataSource()));
        var res = await use.editUser(editedUser);
        res == true
            ? (
                Get.snackbar(
                    "Update details", "User details updated successfully",
                    duration: Duration(seconds: 10), 
                    isDismissible: true,
                    backgroundColor: ThemeData.dark().colorScheme.secondary,
                    colorText: ThemeData.dark().colorScheme.onPrimary),
                    Get.find<SettingsController>().loadUser(),
              )
            : Get.snackbar("Update details",
                "Failed to update user details. Please try again",
                duration: Duration(seconds: 10), 
                isDismissible: true,
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                colorText: ThemeData.dark().colorScheme.onPrimary);
      } on AuthException catch (e) {
        // redendant with badresopnseexcepitonoi to be removed after verification.
        Get.snackbar("invalid tokens", "please login to your account",
            backgroundColor: ThemeData.dark().colorScheme.secondary,
            duration: Duration(seconds: 10), 
            isDismissible: true,
            colorText: ThemeData.dark().colorScheme.onPrimary);
      } on NetworkException catch (e) {
        Get.snackbar(
            "Network Error", "Please check your connection and try again",
            duration: Duration(seconds: 10), 
            isDismissible: true,
            backgroundColor: ThemeData.dark().colorScheme.secondary,
            colorText: ThemeData.dark().colorScheme.onPrimary);
      } on BadResponseException catch (e) {
        if (e.statusCode == 500) {
          Get.snackbar("Server is busy",
              "Having trouble seving your requests, due to too many requests. Please try again later",
              duration: Duration(seconds: 10), 
              isDismissible: true,
              backgroundColor: ThemeData.dark().colorScheme.secondary,
              colorText: ThemeData.dark().colorScheme.onPrimary);
        } else if (e.statusCode == 400) {
          Get.snackbar("Wrong Password",
              "Old Password is Incorrect. Please try again later",
              duration: Duration(seconds: 10), 
              isDismissible: true,
              backgroundColor: ThemeData.dark().colorScheme.secondary,
              colorText: ThemeData.dark().colorScheme.onPrimary);
        }else {
          Get.snackbar("Server is busy",
              "Having trouble seving your requests, due to too many requests. Please try again later",
              duration: Duration(seconds: 10), 
              isDismissible: true,
              backgroundColor: ThemeData.dark().colorScheme.secondary,
              colorText: ThemeData.dark().colorScheme.onPrimary);
        }
      }
    }
    // on CustomeException catch (e) {
    //   Get.toNamed("/error", arguments: {"message": e.toString()});
    // } catch (e) {
    //   print(e.runtimeType);
    //   Get.toNamed("/error", arguments: {"message": "Something went wrong r"});
    // }
  }
}
