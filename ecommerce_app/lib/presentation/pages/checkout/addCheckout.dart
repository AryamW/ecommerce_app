import 'package:ecommerce_app/core/utils/roles.dart';
import 'package:ecommerce_app/data/datasources/api_client.dart';
import 'package:ecommerce_app/presentation/controllers/checkout.dart';
import 'package:ecommerce_app/presentation/widgets/button.dart';
import 'package:ecommerce_app/presentation/widgets/roleBasedAccessControlWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

// a page where you are redirected after make the payment, "return url" destination
class AddCheckout extends StatelessWidget {
  var controller = Get.put(CheckoutController());
  // var controller = Get.find<CheckoutController>();
  AddCheckout({super.key});
  @override
  Widget build(BuildContext context) {
    return const AccessControlWidget(
        allowedRole: Roles.CUSTOMER, child: addCheckoutBody());
  }
}

class addCheckoutBody extends StatelessWidget {
  const addCheckoutBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Get.find<CheckoutController>().fetchAddress();
    return Material(
      child: Container(
          color: Theme.of(context).colorScheme.primary,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const backButton(
                  nextPageName: "/cart",
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Your Payment is Initiated. Please Verify.",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Obx(() {
                      var controller = Get.find<CheckoutController>();
                      print(
                          "fetched adresses in addCheck OBx: ${controller.shippingAddressChoices}");

                      return DropdownMenu(
                        textStyle: TextStyle(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            color: Theme.of(context).colorScheme.onPrimary),
                        onSelected: (value) {
                          print('value: $value');
                          controller.shippingAddress(value);
                        },
                        dropdownMenuEntries: controller.shippingAddressChoices
                            .map((element) {
                              return DropdownMenuEntry(
                                  label: element["street"] +
                                      ", " +
                                      element["city"],
                                  value: element["addressId"]);
                            })
                            .toList()
                            .cast<DropdownMenuEntry>(),
                      );
                    }),
                    SizedBox(
                      height: 30,
                    ),
                    ContinueButton(
                        getController: Get.find<CheckoutController>(),
                        onPress: () async {
                          if (Get.find<CheckoutController>()
                                  .shippingAddress
                                  .value ==
                              null) {
                            Get.find<CheckoutController>()
                                .changeIsLoading(false);
                          }
                          await Get.find<CheckoutController>().verify();
                          return true;
                        },
                        child: Text(
                          "Verify Your Payment",
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
