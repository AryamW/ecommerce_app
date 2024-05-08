import 'package:ecommerce_app/core/utils/exceptions.dart';
import 'package:ecommerce_app/data/data_sources/edit_user.dart';
import 'package:ecommerce_app/data/datasources/api_client.dart';
import 'package:ecommerce_app/data/repositories/edit_user.dart';
import 'package:ecommerce_app/domain/entities/address.dart';
import 'package:ecommerce_app/domain/entities/edit_user.dart';
import 'package:ecommerce_app/domain/usecases/edit_user.dart';
import 'package:ecommerce_app/presentation/controllers/address_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditAddressController extends GetxController {

  final bool createNewAddress;
  bool valid = false;
  late AddressModel? address;
  EditAddressController({required this.createNewAddress}){
  address = Get.arguments?['address'] ?? AddressModel(); 
  if (address!=null){
    streetController.text = address!.street ?? '';
    cityController.text = address!.city ?? '';
    stateController.text = address!.state ?? '';
    countryController.text = address!.country ?? '';
    postalCodeController.text = address!.postalCode ?? '';
    }
  }
  DioClient dio = DioClient();
  // final firstName = "".obs;
  // final lastName = "".obs;
  // final email = "".obs;
  // final phone = "".obs;
  // final password = "".obs;
  // final confirmPass = "".obs;


  RxnString streetError = RxnString(null);
  RxnString cityError = RxnString(null);
  RxnString stateError = RxnString(null);
  RxnString countryError = RxnString(null);
  RxnString postalCodeError = RxnString(null);
  RxnString confirmError = RxnString(null);


  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

 final RegExp alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)?$');
 

  void validateStreet() {
    if (streetController.text.removeAllWhitespace.length < 3 && streetController.text.isNotEmpty) {
      streetError.value = "Street address must be at least 3 characters";
      valid = false;
    }else if(!alphanumericRegex.hasMatch(streetController.text.removeAllWhitespace)&& streetController.text.isNotEmpty){
      streetError.value = "Product Name must be letters and numbers only";
      valid = false;
    }
     else {
      streetError.value = null;
      valid = true;
    }
  }

  void validateCity() {
    if (cityController.text.removeAllWhitespace.length < 3 && cityController.text.isNotEmpty) {
      cityError.value = "City name must be at least 3 letters";
    } else if(!alphanumericRegex.hasMatch(cityController.text.removeAllWhitespace)&& cityController.text.isNotEmpty){
      cityError.value = "City name must be letters and numbers only";
      valid = false;
    } else {
      cityError.value = null;
      valid = true;
    }
  }

  void validateState() {
    if (stateController.text.removeAllWhitespace.length < 3  && stateController.text.isNotEmpty) {
      stateError.value = "City name must be at least 3 letters";
    } else if(!alphanumericRegex.hasMatch(stateController.text.removeAllWhitespace)&& stateController.text.isNotEmpty){
      stateError.value = "State name must be letters and numbers only";
      valid = false;
    } else {
      stateError.value = null;
      valid = true;
    }
  }
  void validateCountry() {
    if (countryController.text.removeAllWhitespace.length < 3 && countryController.text.isNotEmpty) {
      countryError.value = "Country name must be at least 3 characters";
      valid = false;
    }else if(!alphanumericRegex.hasMatch(countryController.text.removeAllWhitespace) && countryController.text.isNotEmpty){
      countryError.value = "Country name must be letters only";
      valid = false;
    } else {
      countryError.value = null;
      valid = true;
    }
  }

  void validatePostalCode() {
    if (postalCodeController.text.removeAllWhitespace.length < 5 && postalCodeController.text.isNotEmpty) {
      postalCodeError.value = "Postal code must be at least 5 characters";
      valid = false;
    }else if(!postalCodeController.text.isNumericOnly && postalCodeController.text.isNotEmpty){
      postalCodeError.value = "Postal code must be numbers only";
      valid = false;
    } else {
      postalCodeError.value = null;
      valid = true;
    }
  }


  void validatePasswordNotMatch() {
    if (newPasswordController.text == stateController.text && newPasswordController.text.isNotEmpty) {
      confirmError.value = "Old Password and New Password are the same";
    } else {
      confirmError.value = null;
    }
  }
  void validateChange(AddressModel editedAddress) {
    if (address != null) {
      if (streetController.text != address!.street)
        editedAddress.street = streetController.text;
      if (cityController.text != address!.city)
        editedAddress.city = cityController.text;
      if (stateController.text != address!.state)
        editedAddress.state = stateController.text;
      if (countryController.text != address!.country)
        editedAddress.country = countryController.text;
      if (postalCodeController.text != address!.postalCode)
        editedAddress.postalCode = postalCodeController.text;
    }
  }

  void toEditModel(AddressModel editedAddress) {
    if (address != null) {
      if (editedAddress.street == null || streetController.text == '') {
        editedAddress.street = address!.street;
      }
      if (editedAddress.city == null || cityController.text == '') {
        editedAddress.city = address!.city;
      }
      if (editedAddress.state == null || stateController.text == '') {
        editedAddress.state = address!.state;
      }
      if (editedAddress.country == null || countryController.text == '') {
        editedAddress.country = address!.country;
      }
      if (editedAddress.postalCode == null || postalCodeController.text == '') {
        editedAddress.postalCode = address!.postalCode;
      }
    }
  }

  void submitForm() async {
    validateStreet();
    validateCity();
    validateState();
    validateCountry();
    validatePostalCode();
    // validatePasswordNotMatch();
    var editedAddress = AddressModel();
    if (createNewAddress){
        editedAddress.street = streetController.text;
        editedAddress.city = cityController.text;
        editedAddress.state = stateController.text;
        editedAddress.country = countryController.text;
        editedAddress.postalCode = postalCodeController.text;
    } else {
        validateChange(editedAddress);
        editedAddress.addressId = address!.addressId;
      }
    if (editedAddress.toJson().toString() == {'addressId': editedAddress.addressId}.toString() 
        || editedAddress.toJson().toString() == {}.toString()) {
      //something happens
      Get.snackbar("Nothing to change","Please enter the field you want to edit",
                isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                colorText: ThemeData.dark().colorScheme.onPrimary);
    } 
    else {
      try {
        var use = Get.find<AddressController>();
        var addressType = Get.find<AddressController>().addressType.value;
        if(createNewAddress) {
          var res = false;
          if(addressType){ res = await use.postShippingAddress(editedAddress);}
          else{ res = await use.postBillingAddress(editedAddress);}
          res == true
            ? {
                Get.snackbar(
                    "New Address", "Address created successfully",
                    isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                    colorText: ThemeData.dark().colorScheme.onPrimary),
                    Get.find<AddressController>().loadAddress(),
            }
            : Get.snackbar("Failed",
                "Failed to create new Address. Please try again",
                isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                colorText: ThemeData.dark().colorScheme.onPrimary);
        } else {
          print(editedAddress.toJson().toString());
          toEditModel(editedAddress);
          print(editedAddress.toJson().toString());
          var res = false;
          if(addressType){ res = await use.putShippingAddress(editedAddress);}
          else{ res = await use.putBillingAddress(editedAddress);}
          res == true
            ? {
                Get.snackbar(
                    "Edit Address", "Address edited successfully",
                    isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                    colorText: ThemeData.dark().colorScheme.onPrimary),
                    Get.find<AddressController>().loadAddress(),
            }
            : Get.snackbar("Failed",
                "Failed to edit address details. Please try again",
                isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                colorText: ThemeData.dark().colorScheme.onPrimary);
        }
      } on AuthException catch (e) {
        // redendant with badresopnseexcepitonoi to be removed after verification.
        Get.snackbar("invalid tokens", "please login to your account",
            isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
            colorText: ThemeData.dark().colorScheme.onPrimary);
      } on NetworkException catch (e) {
        Get.snackbar(
            "Network Error", "Please check your connection and try again",
            isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
            colorText: ThemeData.dark().colorScheme.onPrimary);
      } on BadResponseException catch (e) {
        if (e.statusCode == 500) {
          Get.snackbar("Server is busy",
              "Having trouble seving your requests, due to too many requests. Please try again later",
              isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
              colorText: ThemeData.dark().colorScheme.onPrimary);
        } else if (e.statusCode == 400) {
          Get.snackbar("Bad Request",
              "One or more field are incorrect. Please try again",
              isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
              colorText: ThemeData.dark().colorScheme.onPrimary);
        } else if (e.statusCode == 401) {
          Get.snackbar("Invalid Token",
              "please login to your account and try again",
              isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
              colorText: ThemeData.dark().colorScheme.onPrimary);
        } else if (e.statusCode == 404) {
          Get.snackbar("No address found",
              "The address you are trying to access is removed or has been moved",
              isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
              colorText: ThemeData.dark().colorScheme.onPrimary);
        } else {
          Get.snackbar("Server is busy",
              "Having trouble seving your requests, due to too many requests. Please try again later",
              isDismissible: true,
                duration: Duration(seconds: 10),
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
void deleteAddress() async {

  try {
      var use = Get.find<AddressController>();
      var addressType = Get.find<AddressController>().addressType.value;
        if(address?.addressId != null ) {
          var res = false;
          if(addressType){ res = await use.deleteShippingAddress(address!.addressId!);}
          else{ res = await use.deleteBillingAddress(address!.addressId!);}
          res == true
            ? {
                Get.snackbar(
                    "Address Deleted", "Address deleted successfully",
                    isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                    colorText: ThemeData.dark().colorScheme.onPrimary),
                    Get.find<AddressController>().loadAddress(),
            }
            : Get.snackbar("Failed",
                "Failed to delete address. Please try again",
                isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                colorText: ThemeData.dark().colorScheme.onPrimary);
        }
  } on AuthException catch (e) {
        // redendant with badresopnseexcepitonoi to be removed after verification.
        Get.snackbar("invalid tokens", "please login to your account",
            isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
            colorText: ThemeData.dark().colorScheme.onPrimary);
      } on NetworkException catch (e) {
        Get.snackbar(
            "Network Error", "Please check your connection and try again",
            isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
            colorText: ThemeData.dark().colorScheme.onPrimary);
      } on BadResponseException catch (e) {
        if (e.statusCode == 500) {
          Get.snackbar("Server is busy",
              "Having trouble seving your requests, due to too many requests. Please try again later",
              isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
              colorText: ThemeData.dark().colorScheme.onPrimary);
        } else if (e.statusCode == 400) {
          Get.snackbar("Bad Request",
              "One or more field are incorrect. Please try again",
              isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
              colorText: ThemeData.dark().colorScheme.onPrimary);
        } else if (e.statusCode == 401) {
          Get.snackbar("Invalid Token",
              "please login to your account and try again",
              isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
              colorText: ThemeData.dark().colorScheme.onPrimary);
        } else if (e.statusCode == 404) {
          Get.snackbar("No address found",
              "The address you are trying to access is removed or has been moved",
              isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
              colorText: ThemeData.dark().colorScheme.onPrimary);
        } else {
          Get.snackbar("Server is busy",
              "Having trouble seving your requests, due to too many requests. Please try again later",
              isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
              colorText: ThemeData.dark().colorScheme.onPrimary);
        }
      }
    }
}