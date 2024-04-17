import 'package:ecommerce_app/presentation/controllers/checkout.dart';
import 'package:ecommerce_app/presentation/widgets/button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

// a page where you are redirected after make the payment, "return url" destination
class AddCheckout extends StatelessWidget {
  var controller = Get.put(CheckoutController());
  AddCheckout({super.key});
  @override
  Widget build(BuildContext context) {
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
                    // Obx(() => 
                    //  DropdownButton(),
                    // ),
                    ContinueButton(
                        onPress: () {
                          print("yes");
                          Get.find<CheckoutController>().verify();
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
