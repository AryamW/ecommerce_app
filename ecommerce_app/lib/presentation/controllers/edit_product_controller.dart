import 'dart:async';
import 'dart:io';

import 'package:ecommerce_app/core/utils/category_enum.dart';
import 'package:ecommerce_app/core/utils/exceptions.dart';
import 'package:ecommerce_app/data/datasources/edit_product.dart';
import 'package:ecommerce_app/data/datasources/api_client.dart';
import 'package:ecommerce_app/data/repositories/edit_product.dart';
import 'package:ecommerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/domain/usecases/edit_product.dart';
import 'package:ecommerce_app/presentation/controllers/admin_table_controller.dart';
import 'package:ecommerce_app/presentation/pages/admin/edit_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';

class EditProductController extends GetxController {
AdminProduct adminProduct = AdminProduct();

 Rx<AdminProduct> ap = AdminProduct().obs;
 var imgList = [].obs;
@override
EditProductController(){
  //print("getAP: ${Get.arguments?['product']?.id}");
  var apid = Get.arguments?['product']?.id;
  //print("getAPid: ${apid}");
 if(Get.arguments?['product'] != null){ 
  getAP(Get.arguments?['product']?.id);}
}

void getAP(int apid) async{
  var use = EditProductCase(
            repo:
                EditProductRepositoryImpl(editProductProvider: EditProductDataSource()));
                //print("getAP: ${apid}");
                ap.value = await use.getProduct(apid) ?? AdminProduct();
                start();
                // //print(imgList.value);

}

void start() {
    //print("fffffffffffff${ap.value.id}");
    // if(ap.id!=null) {getProduct(ap.id!);}
    if(ap.value.toAdminJson().toString() != {}.toString())
    {
      NameController.text = ap.value.name.toString();
      BrandController.text = ap.value.brand.toString();
      DetailController.text = ap.value.details.toString();
      CountController.text = ap.value.count.toString();
      PriceController.text = ap.value.price.toString();
      CategoryController.text = ap.value.category.toString();
      id = ap.value.id;
      imgList.value = ap.value.imageUrl!;
      ap.value.imageUrl.obs;
    }
  }




void getProduct(int apid) async{
  var use = EditProductCase(
            repo:
                EditProductRepositoryImpl(editProductProvider: EditProductDataSource()));
adminProduct = await use.getProduct(apid)?? AdminProduct();

}

@override
  void refresh() {
    // //print("fffffffffffff${adminProduct.id}");
    // if(adminProduct.id!=null) {getProduct(adminProduct.id!);}
    // if (adminProduct != null){
    //   NameController.text = adminProduct!.name.toString();
    //   BrandController.text = adminProduct!.brand.toString();
    //   DetailController.text = adminProduct!.details.toString();
    //   CountController.text = adminProduct!.count.toString();
    //   PriceController.text = adminProduct!.price.toString();

    //   id = adminProduct!.id;
    // }
            imgList.clear();
            selectedImages.clear();
            if(Get.arguments?['product'] != null){ 
  getAP(Get.arguments?['product'].id);}

    super.refresh();
  }

  // final name = "".obs;
  // final brand = "".obs;
  // final details = "".obs;
  // final count = "".obs;
  // final price = "".obs;
  // final images = "".obs;
  // final category = "".obs;


bool valid = false;
  List<String> categoriesEnum = Category.values.map((e) => e.name).toList();

  RxnString NameError = RxnString(null);
  RxnString BrandError = RxnString(null);
  RxnString DetailError = RxnString(null);
  RxnString CountError = RxnString(null);
  RxnString PriceError = RxnString(null);
  RxnString ImagesError = RxnString(null);
  RxnString CategoryError = RxnString(null);
int? id;

var selectedImages = <String>[].obs;
  
  File? image;
  RxBool imageIsSet = false.obs;
  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? ximage = await _picker.pickImage(source: ImageSource.gallery);

    if(image !=null) {unPickImage();}

    if (ximage != null) {
      image = File(ximage.path);
      ImagesController.text = ximage.path;
      imageIsSet.value =true;
    } else {
      //print('No image selected.');
    }
  }
  void unPickImage(){
    image = null;
    imageIsSet.value =false;
  }
  TextEditingController NameController = TextEditingController();
  TextEditingController BrandController = TextEditingController();
  TextEditingController DetailController = TextEditingController();
  TextEditingController CountController = TextEditingController();
  TextEditingController PriceController = TextEditingController();
  TextEditingController ImagesController = TextEditingController();
  TextEditingController CategoryController = TextEditingController();


  final RegExp alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
  
  void validateName() {
    if (NameController.text.length < 3 ) {
      NameError.value = "Product Name must be at least 3 characters";
      valid = false;
    }else if(!alphanumericRegex.hasMatch(NameController.text.removeAllWhitespace)){
      NameError.value = "Product Name must be letters and numbers only";
      valid = false;
    } else {
      NameError.value = null;
      valid = true;
    }
  }
  void validateBrand() {
    if (BrandController.text.length < 3 ) {
      BrandError.value = "Brand Name must be at least 3 characters";
      valid = false;
    }else if(!alphanumericRegex.hasMatch(BrandController.text.removeAllWhitespace)){
      BrandError.value = "Brand Name must be letters and numbers only";
      valid = false;
    } else {
      BrandError.value = null;
      valid = true;
    }
  }  
  void validateDetail() {
    if (DetailController.text.length < 3 ) {
      DetailError.value = "Detail must be at least 3 characters";
      valid = false;
    }else if(!alphanumericRegex.hasMatch(DetailController.text.removeAllWhitespace)){
      DetailError.value = "Detail must be letters and numbers only";
      valid = false;
    } else {
      DetailError.value = null;
      valid = true;
    }
  }
  void validateCount() {
    if(!CountController.text.removeAllWhitespace.isNumericOnly){
      CountError.value = "Must be numbers only";
      valid = false;
    }else {
      CountError.value = null;
      valid = true;
    }
  }  
  void validatePrice() {
    if(!PriceController.text.removeAllWhitespace.isCurrency){
      PriceError.value = "Must be numbers only";
      valid = false;
    } else {
      PriceError.value = null;
      valid = true;
    }
  } 
  void validateImages() {
    var urls = ImagesController.text.split('\n');
    if (!urls.every((element) => element.isURL) ) {
      ImagesError.value = "Please enter image urls separately on each line and remove all whitespaces";
      valid = false;
    } else {
      ImagesError.value = null;
      valid = true;
    }
  }
  void validateCategory() {
    if (!categoriesEnum.contains(CategoryController.text) ) {
      CategoryError.value = "Please choose a valid category";
      valid = false;
    } else {
      CategoryError.value = null;
      valid = true;
    }
  }

  void submitForm() async {
    
    validateName();
    validateBrand();
    validateDetail();
    validateCount();
    validatePrice();
    // validateImages();
    validateCategory();
    var editedProduct = AdminProduct();
      editedProduct.name = NameController.text;
        editedProduct.price = double.tryParse(PriceController.text);
        if(ImagesController.text!="") editedProduct.imageUrl= ImagesController.text.split('\n');
        editedProduct.id = Get.arguments['product'].id;
        editedProduct.brand = BrandController.text;
        editedProduct.details = DetailController.text;
        editedProduct.count = int.tryParse(CountController.text);
        editedProduct.category = CategoryController.text;
        editedProduct.imgFiles = image;
    if (editedProduct.toAdminJson().toString() == Get.arguments['product']?.toAdminJson()?.toString()) {
      //something happens
      Get.snackbar("Nothing to change","Please enter the field you want to edit",
                isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                colorText: ThemeData.dark().colorScheme.onPrimary);
    }  else if (editedProduct.toAdminJson().toString() == Get.arguments['product']?.toAdminJson().toString()) {
      //something happens
      Get.snackbar("Nothing to change","Please enter the field you want to edit",
                isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                colorText: ThemeData.dark().colorScheme.onPrimary);
    } 
    else if (editedProduct.toAdminJson().toString() == {}.toString()) {
      //something happens
      Get.snackbar("Nothing to change","All fields are empty. Please enter the field you want to edit",
                isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                colorText: ThemeData.dark().colorScheme.onPrimary);
    } 
    else if (valid){
      try {
        var use = EditProductCase(
            repo:
                EditProductRepositoryImpl(editProductProvider: EditProductDataSource()));
          var res = await use.editProduct(editedProduct);
          if(res == true)
              {
                 
                 unPickImage();
                 refresh();
                  Get.snackbar(
                      "Update Product", "Product updated successfully",
                      isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                      colorText: ThemeData.dark().colorScheme.onPrimary);
                      Future.sync(() => Get.find<AdminTableController>().refresh());
                } 
                else {Get.snackbar("Update details",
                  "Failed to update Product details. Please try again",
                  isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                  colorText: ThemeData.dark().colorScheme.onPrimary);}
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
        } else {
          Get.snackbar("Unknown Error Occurred",
              e.message,
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
    //   //print(e.runtimeType);
    //   Get.toNamed("/error", arguments: {"message": "Something went wrong r"});
    // }
  }



  void addProduct() async {
    
    validateName();
    validateBrand();
    validateDetail();
    validateCount();
    validatePrice();
    // validateImages();
    validateCategory();
    var editedProduct = AdminProduct();
      editedProduct.name = NameController.text;
        editedProduct.price = double.tryParse(PriceController.text);
        editedProduct.brand = BrandController.text;
        editedProduct.details = DetailController.text;
        editedProduct.count = int.tryParse(CountController.text);
        editedProduct.category = CategoryController.text;
        editedProduct.imgFiles = image;
        if (editedProduct.toAdminJson().toString() == {}.toString()) {
      //something happens
      Get.snackbar("Nothing to change","All fields are empty. Please enter the field you want to edit",
                isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                colorText: ThemeData.dark().colorScheme.onPrimary);
    } else if (valid){
      try {
        var use = EditProductCase(
            repo:
                EditProductRepositoryImpl(editProductProvider: EditProductDataSource()));
          var res=  await use.addProduct(editedProduct);
          if(res !=null)
               
                 {
                  Get.snackbar(
                      "New Product", "Product created successfully",
                      isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                      colorText: ThemeData.dark().colorScheme.onPrimary,
                  onTap: (snack) {
                    Get.offUntil(GetPageRoute(page: ()=>EditProduct(),
                    settings: RouteSettings(arguments: {'product':res})), ((route) {
                      //print("route:$route.");
                      return route.settings.name == "/adminProducts";
                    } ));
                  },
                    );
                      Future.sync(() => Get.find<AdminTableController>().refresh());
                      // Future.sync(() => Get.off(()=> EditProduct(),arguments: {'product': res}));
                
              } else {Get.snackbar("Product Not Created",
                  "Failed to create new product. Please try again",
                  isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                  colorText: ThemeData.dark().colorScheme.onPrimary,
                  );
              }
      } on AuthException catch (e) {
        // redendant with badresopnseexcepitonoi to be removed after verification.
        Get.snackbar("invalid tokens", "please login to your account",
            isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
            colorText: ThemeData.dark().colorScheme.onPrimary,
                    );
      } on NetworkException catch (e) {
        Get.snackbar(
            "Network Error", "Please check your connection and try again",
            isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
            colorText: ThemeData.dark().colorScheme.onPrimary,
                    );
      } on BadResponseException catch (e) {
        if (e.statusCode == 500) {
          Get.snackbar("Server is busy",
              "Having trouble seving your requests, due to too many requests. Please try again later",
              isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
              colorText: ThemeData.dark().colorScheme.onPrimary,
                    );
        } else {
          Get.snackbar("Unknown Error Occurred",
              e.message,
              isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
              colorText: ThemeData.dark().colorScheme.onPrimary,
                    );
        }
      }
    }
    // on CustomeException catch (e) {
    //   Get.toNamed("/error", arguments: {"message": e.toString()});
    // } catch (e) {
    //   //print(e.runtimeType);
    //   Get.toNamed("/error", arguments: {"message": "Something went wrong r"});
    // }
  }
void deleteProduct() async{
  try {
        if(id != null){
          var use = EditProductCase(
            repo:
                EditProductRepositoryImpl(editProductProvider: EditProductDataSource()));
          var res=  await use.deleteProduct(id!);
          if(res == true)
               {
                  Get.snackbar(
                      "Product Deleted", "Product deleted successfully",
                      isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                      colorText: ThemeData.dark().colorScheme.onPrimary,
                    );
                      Get.find<AdminTableController>().refresh();
                      Get.until((route) => Get.currentRoute == "/adminProducts" );
                      // Future.sync(() => Get.off(()=> EditProduct(),arguments: {'product': res})),
                }
               else{Get.snackbar("Product Not Deleted",
                  "Failed to delete product. Please try again",
                  isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                  colorText: ThemeData.dark().colorScheme.onPrimary,
                    );
                }
              }
      } on AuthException catch (e) {
        // redendant with badresopnseexcepitonoi to be removed after verification.
        Get.snackbar("invalid tokens", "please login to your account",
            isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
            colorText: ThemeData.dark().colorScheme.onPrimary,
                    );
      } on NetworkException catch (e) {
        Get.snackbar(
            "Network Error", "Please check your connection and try again",
            isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
            colorText: ThemeData.dark().colorScheme.onPrimary,
                    );
      } on BadResponseException catch (e) {
        if (e.statusCode == 500) {
          Get.snackbar("Server is busy",
              "Having trouble seving your requests, due to too many requests. Please try again later",
              isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
              colorText: ThemeData.dark().colorScheme.onPrimary,
                    );
        } else {
          Get.snackbar("Unknown Error Occurred",
              e.message,
              isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
              colorText: ThemeData.dark().colorScheme.onPrimary,
                    );
        }
      }
    }


void deleteImage() async{
  try {
    //print(id);

        if(selectedImages.isNotEmpty && id != null){
          var use = EditProductCase(
            repo:
                EditProductRepositoryImpl(editProductProvider: EditProductDataSource()));
                var selectedImagesToQuery = [];
                selectedImages.forEach((element) {
                  selectedImagesToQuery.add(element.split("/").last);
                });
                // //print("bsdfbdsfbzdf${selectedImagesToQuery.join(',')}");
          var res=  await use.deleteImage(id!, selectedImagesToQuery);
          if(res == true){
                    refresh();
                    selectedImages.forEach((element) {
                  adminProduct.imageUrl?.remove(element);
                });
                //print("string${adminProduct.imageUrl.toString()}");
                    Future.sync(() => Get.find<EditProductController>().refresh());
                  Get.snackbar(
                      "Image Deleted", "Product Image deleted successfully",
                      isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                      colorText: ThemeData.dark().colorScheme.onPrimary,
                    );
                      Future.sync(() => Get.find<AdminTableController>().refresh());
                      // Future.sync(() => Get.off(()=> EditProduct(),arguments: {'product': res})),
          } else {
               Get.snackbar("Image Not Deleted",
                  "Failed to delete product image. Please try again",
                  isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                  colorText: ThemeData.dark().colorScheme.onPrimary,
                    );
          }
              }
      } on AuthException catch (e) {
        // redendant with badresopnseexcepitonoi to be removed after verification.
        Get.snackbar("invalid tokens", "please login to your account",
            isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
            colorText: ThemeData.dark().colorScheme.onPrimary,
                    );
      } on NetworkException catch (e) {
        Get.snackbar(
            "Network Error", "Please check your connection and try again",
            isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
            colorText: ThemeData.dark().colorScheme.onPrimary,
                    );
      } on BadResponseException catch (e) {
        if (e.statusCode == 500) {
          Get.snackbar("Server is busy",
              "Having trouble seving your requests, due to too many requests. Please try again later",
              isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
              colorText: ThemeData.dark().colorScheme.onPrimary,
                    );
        } else {
          Get.snackbar("Unknown Error Occurred",
              e.message,
              isDismissible: true,
                duration: Duration(seconds: 10),
                backgroundColor: ThemeData.dark().colorScheme.secondary,
              colorText: ThemeData.dark().colorScheme.onPrimary,
                    );
        }
      }
    }





}
