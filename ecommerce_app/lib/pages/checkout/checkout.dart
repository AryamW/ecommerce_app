import 'package:flutter/material.dart';
import 'package:ecommerce_app/widgets/button.dart';
class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    double minHeight = 840;
    print(maxHeight);
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primary,
          alignment: Alignment.center,
        child: Container(
          color: Theme.of(context).colorScheme.tertiary,
          child: SingleChildScrollView(
            child: Container(
                width: 500,
                height: maxHeight > minHeight ? maxHeight : minHeight,
                // height: 800,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  
                    Expanded(
                      flex: 2,
                      child: Container(
                          alignment: Alignment.center,
                          color: Theme.of(context).colorScheme.tertiary,
                          child: Container(
                            child: Image.asset(
                              "lib/assets/images/image 3.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                    ),
                
                     Expanded(
                      flex: 1,
                       child: Container(
                          padding: EdgeInsets.all(20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Order Placed Successfully",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 32,
                                    color: Theme.of(context).colorScheme.onPrimary),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "You will recieve an email confirmation.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.onPrimary),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              ContinueButton(
                                onPress: () => print("See Other Details"),
                                child: Text(
                                  "See Other Details",
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                     ),
                    
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
