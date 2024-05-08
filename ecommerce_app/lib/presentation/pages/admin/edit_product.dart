import 'package:ecommerce_app/core/utils/category_enum.dart';
import 'package:ecommerce_app/core/utils/roles.dart';
import 'package:ecommerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/presentation/controllers/edit_product_controller.dart';
import 'package:ecommerce_app/presentation/widgets/roleBasedAccessControlWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class EditProduct extends StatelessWidget {
  EditProduct({
    super.key,
  });
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final EditProductController controller = Get.put(EditProductController());
    final AdminProduct? product = controller.ap.value;
    return AccessControlWidget(
      allowedRole: Roles.ADMIN,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              constraints: BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 20, bottom: 30),
                    child: Row(
                      children: [
                        Ink(
                          decoration: ShapeDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              shape: CircleBorder()),
                          child: IconButton(
                            onPressed: () => Get.back(),
                            icon: ImageIcon(
                              color: Theme.of(context).colorScheme.onSecondary,
                              AssetImage(
                                "lib/assets/images/arrowleft2.png",
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Text(
                          product!=null? "Edit Product": "Add Product",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Spacer(),
                      ],
                    ),
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              constraints: BoxConstraints(maxWidth: 500),
                              child: TextFormField(
                                controller: controller.NameController,
                                validator: (value) {
                                  controller.validateName();
                                  return controller.NameError.value;
                                },
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary),
                                decoration: InputDecoration(
                                    hintText: product?.name ?? "Product Name",
                                    hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary),
                                    labelText: "Name",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    floatingLabelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                    labelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                    border: OutlineInputBorder(
                                        // borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    fillColor:
                                        Theme.of(context).colorScheme.secondary,
                                    filled: true),
                                
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              constraints: BoxConstraints(maxWidth: 500),
                              child: TextFormField(
                                controller: controller.BrandController,
                                validator: (value) {
                                  controller.validateBrand();
                                  return controller.BrandError.value;
                                },
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary),
                                decoration: InputDecoration(
                                    hintText: product?.brand ?? "Product Brand",
                                    hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary),
                                    labelText: "brand",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    floatingLabelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                    labelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                    border: OutlineInputBorder(
                                        // borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    fillColor:
                                        Theme.of(context).colorScheme.secondary,
                                    filled: true),
                                
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              constraints: BoxConstraints(maxWidth: 500),
                              child: TextFormField(
                                maxLines: 5,
                                controller: controller.DetailController,
                                validator: (value) {
                                  controller.validateDetail();
                                  return controller.DetailError.value;
                                },
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary),
                                decoration: InputDecoration(
                                    hintText: product?.details ?? "Product Details",
                                    hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary),
                                    labelText: "Details",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    floatingLabelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                    labelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                    border: OutlineInputBorder(
                                        // borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    fillColor:
                                        Theme.of(context).colorScheme.secondary,
                                    filled: true),
                                
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              constraints: BoxConstraints(maxWidth: 500),
                              child: TextFormField(
                                controller: controller.CountController,
                                validator: (value) {
                                  controller.validateCount();
                                  return controller.CountError.value;
                                },
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary),
                                decoration: InputDecoration(
                                    hintText: "${product?.count ?? "Number of items in stock "}",
                                    hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary),
                                    labelText: "Number of items available",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    floatingLabelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                    labelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                    border: OutlineInputBorder(
                                        // borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    fillColor:
                                        Theme.of(context).colorScheme.secondary,
                                    filled: true),
                                
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              constraints: BoxConstraints(maxWidth: 500),
                              child: TextFormField(
                                controller: controller.PriceController,
                                validator: (value) {
                                  controller.validatePrice();
                                  return controller.PriceError.value;
                                },
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary),
                                decoration: InputDecoration(
                                    hintText: "${product?.price ?? "Price"}",
                                    hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary),
                                    labelText: "Price",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    floatingLabelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                    labelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                    border: OutlineInputBorder(
                                        // borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    fillColor:
                                        Theme.of(context).colorScheme.secondary,
                                    filled: true),
                                
                              ),
                            ),
                          ),
                          
                          Obx(
                            () => DropdownMenu(
                              initialSelection: product?.category,
                              enableFilter: true,
                              enableSearch: false,
                              errorText: controller.CategoryError.value,
                              controller: controller.CategoryController,
                              onSelected: (value) {
                                controller.validateCategory();
                                if (value != null) {
                                  controller.CategoryController.text = value;
                                }
                              },
                              dropdownMenuEntries: categoryToList(),
                              label: Text("Category"),
                              inputDecorationTheme: InputDecorationTheme(
                                fillColor:
                                    Theme.of(context).colorScheme.secondary,
                                filled: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                floatingLabelStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary),
                                labelStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary),
                              ),
                              menuStyle: MenuStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Theme.of(context).colorScheme.secondary),
                                shadowColor: MaterialStatePropertyAll(
                                    Theme.of(context).colorScheme.onPrimary),
                                elevation: MaterialStatePropertyAll(2),
                                surfaceTintColor: MaterialStatePropertyAll(
                                    Theme.of(context).colorScheme.onPrimary),
                              ),
                              textStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary),
                            ),
                          ),
                          
                              SizedBox(height: 20,),
                              Center(child: Text("Images",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,),)),
                              SizedBox(height: 10,),
                          Obx(
                            () => IconButton(
                                                onPressed: () {
                                              if(controller.selectedImages.isNotEmpty) {Get.bottomSheet(DialogButton(controller: controller,isProduct: false,));}
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: controller.selectedImages.isNotEmpty? Colors.red: Theme.of(context).colorScheme.secondary,
                                                )),
                          ),
                          //  Container(
                          //     decoration: BoxDecoration(
                          //       color: Theme.of(context).colorScheme.secondary,
                          //     ),
                          //     // constraints:  BoxConstraints(maxHeight: 130),
                          //     height: MediaQuery.of(context).size.width * 0.25,
                          //     width: MediaQuery.of(context).size.width * 0.5,
                          //     child: GridView.builder(
                          //       padding: EdgeInsets.all(5),
                          //           itemCount: product?.imageUrl?.length ?? 0 ,
                          //           gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          //             maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.25,
                          //             crossAxisSpacing: 10,
                          //             mainAxisSpacing: 10,
                          //             // mainAxisExtent: 100,
                          //           ),
                          //           itemBuilder: (context, index) {
                          //             return SelectableImage(controller: controller,imageUrl: product?.imageUrl?[index],);
                          //             // return Image.network(product?.imageUrl[index]);
                          //           },
                          //         ),
                          //   ),
SizedBox(height:  20),
                            Obx(()=> controller.imgList.isNotEmpty ?
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              // constraints:  BoxConstraints(maxHeight: 130),
                              height: MediaQuery.of(context).size.width * 0.25,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child:  GridView.builder(
                                  padding: EdgeInsets.all(5),
                                      itemCount: controller.imgList.length,
                                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.25,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        // mainAxisExtent: 100,
                                      ),
                                      itemBuilder: (context, index) {
                                        print("${controller.imgList.length},${controller.imgList[index]}");
                                        return SelectableImage(controller: controller,imageUrl: controller.imgList[index],);
                                        // return Image.network(product?.imageUrl[index]);
                                      },
                                    ),
                              )
                            
                            
                            : Center(
                                        child: Text("Product has no Images", style: TextStyle(
                                                                        color:
                                                                            Theme.of(context).colorScheme.onPrimary),),
                                      ),
                         ),
                              SizedBox(height: 20,),
Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              constraints: BoxConstraints(maxWidth: 500),
                              child: Obx(
                                  () => controller.imageIsSet.isTrue
                                      ? Stack(children: [
                                          Image.file(controller.image!),
                                          IconButton(
                                              onPressed: () {
                                                controller.unPickImage();
                                              },
                                              icon: Icon(
                                                Icons.cancel_outlined,
                                                color: Colors.red,
                                              ))
                                        ])
                                      : Center(
                                        child: Text("No Image Selected", style: TextStyle(
                                                                        color:
                                                                            Theme.of(context).colorScheme.onPrimary),),
                                      ),
                              )
                            ),
                          ),


                ElevatedButton(
                            onPressed: controller.pickImage,
                            child: Text(
                              'Pick Image',
                              style: TextStyle(
                                  color:Theme.of(context).colorScheme.tertiary),),
                  ),

                          SizedBox(height: 30),
                          if (Get.arguments?['product'] != null) Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              constraints: BoxConstraints(maxWidth: 300),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    controller.submitForm();
                                    // Proceed with form submission
                                    // Get.toNamed("/home");
                                  }
                                },
                                child: Text("Edit"),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Theme.of(context).colorScheme.tertiary),
                                  foregroundColor:
                                      MaterialStatePropertyAll(Colors.white),
                                  // minimumSize: MaterialStatePropertyAll(25 as Size?),
                                ),
                              ),
                            ),
                          ),
                          if (Get.arguments?['product'] == null) Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                            child: ElevatedButton(
                              onPressed: () {if (_formKey.currentState!.validate()) {
                                    controller.addProduct();
                                    // Proceed with form submission
                                    // Get.toNamed("/home");
                                  }},
                              child: Text("Add product"),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Theme.of(context).colorScheme.tertiary),
                                  foregroundColor: MaterialStatePropertyAll(Colors.white),),
                            ),
                          ),
                          if (Get.arguments?['product'] != null) Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                Get.bottomSheet(DialogButton(controller: controller,isProduct: true,));
                              },
                              child: Text("delete product"),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.red),
                                  foregroundColor: MaterialStatePropertyAll(
                                      Theme.of(context).colorScheme.onPrimary)),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductFormField extends StatelessWidget {
  const ProductFormField({
    super.key,
    required this.fieldName,
    this.keyboardType = TextInputType.text,
  });
  final TextInputType? keyboardType;
  final String fieldName;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 500),
        child: TextFormField(
          keyboardType: keyboardType,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          decoration: InputDecoration(
              hintText: fieldName,
              hintStyle: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSecondary),
              labelText: fieldName,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              floatingLabelStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              labelStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              border: OutlineInputBorder(
                  // borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              fillColor: Theme.of(context).colorScheme.secondary,
              filled: true),
          // controller: ,
          // validator: (value) {
          //   // editUserController.validateLastName();
          //   // return editUserController.lastNameError.value;
          // },
        ),
      ),
    );
  }
}

List<DropdownMenuEntry> categoryToList() {
  final ButtonStyle btnStyle = ButtonStyle(
    backgroundColor:
        MaterialStatePropertyAll(ThemeData.dark().colorScheme.primary),
  );
  var categoryList = List.generate(
      Category.values.length,
      (index) => DropdownMenuEntry(
          value: Category.values[index].name,
          label: Category.values[index].name,
          style: btnStyle));

  if (categoryList.isNotEmpty)
    return categoryList;
  else
    return [];
}



class SelectableImage extends StatelessWidget {
  final String imageUrl;
  final EditProductController controller;

  SelectableImage(
      {super.key, required this.imageUrl, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () {
          if (controller.selectedImages.contains(imageUrl) == false) {
            controller.selectedImages.add(imageUrl);
            print(controller.selectedImages);
          } else {
            controller.selectedImages.removeWhere((item) => item == imageUrl);
            print(controller.selectedImages);
          }
        },
        child: Container(
          height: 100,
          constraints: BoxConstraints.tight(Size(100, 100)),
          decoration: BoxDecoration(
            border: Border.all(
                color: controller.selectedImages.contains(imageUrl)
                    ? Colors.red
                    : Theme.of(context).colorScheme.primary,
                width: 5.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Image.network(
            imageUrl,
            height: 50,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              if (error.runtimeType == NetworkImageLoadException) {
                var e = error as NetworkImageLoadException;
                if (e.statusCode == 404) {
                  return Center(
                      child: Text(
                    "This Image Does Not Exist in the Server. Please delete it immediately and upload another one",
                    style: TextStyle(color: Colors.red),
                  ));
                }
              }
              // print(error.runtimeType);
              return Image.network(
                "https://red-ecommerce.onrender.com/images/DefaultImage.jpg",
                width: double.maxFinite,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset("lib/assets/images/DefaultImage.jpg");
                },
              );
            },
          ),
        ),
      ),
    );
  }
}



class DialogButton extends StatelessWidget {
  final EditProductController controller;
  final bool isProduct;
  const DialogButton({
    super.key, required this.controller, required this.isProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 300,
        maxWidth: 500,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(isProduct? "Are you sure you want to delete this product?": "Are you sure you want to delete this Image?",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          textAlign: TextAlign.center,),
          SizedBox(
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      if (isProduct) {
                      controller.deleteProduct();
                      Get.back();
                    } else {
                      controller.deleteImage();
                      Get.back();
                    }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.tertiary),
                        foregroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.onPrimary),
                        // minimumSize: MaterialStatePropertyAll(25 as Size?),
                        ),
                child: Text("Yes"),
                        ),
                        TextButton(
                    onPressed: () {
                      Get.back();
                    },style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.secondary),
                        foregroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.onPrimary),
                        // minimumSize: MaterialStatePropertyAll(25 as Size?),
                        ),
                child: Text("No"),
                        ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
