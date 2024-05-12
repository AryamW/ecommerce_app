import 'package:ecommerce_app/presentation/controllers/auth.dart';
import 'package:ecommerce_app/presentation/widgets/button.dart';
import 'package:ecommerce_app/presentation/widgets/myTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  ForgotPasswordController forgotPasswordController =
      Get.put(ForgotPasswordController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: const backButton(
          nextPageName: "/login",
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 800,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Forgot Password",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary)),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          child: myTextField(
                            controller:
                                forgotPasswordController.emailController,
                            validator: (value) {
                              forgotPasswordController.validateEmail(
                                  forgotPasswordController
                                      .emailController.text);
                              return forgotPasswordController.emailError.value;
                            },
                            keyboardType: TextInputType.emailAddress,
                            palceholder: "Email Address",
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ContinueButton(
                          getController: forgotPasswordController,
                          onPress: () async {
                            if (_formKey.currentState!.validate()) {
                              // Proceed with form submission
                              await forgotPasswordController.initiate();
                            } else {
                              forgotPasswordController.changeIsLoading(false);
                            }
                            return true;
                          },
                          child: Text(
                            "Continue",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmailSent extends StatelessWidget {
  EmailSent({super.key});
  ForgotPasswordController forgotController =
      Get.put(ForgotPasswordController());

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("build");
    return Material(
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
                width: 800,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Image.asset(
                      "lib/assets/images/image 4.png",
                      fit: BoxFit.contain,
                    ),
                    Text(
                      "We Sent You an Email to reset your password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            child: myTextField(
                              controller:
                                  forgotController.newPasswordController,
                              validator: (value) {
                                forgotController.validatePassword();
                                return forgotController.passwordError.value;
                              },
                              keyboardType: TextInputType.visiblePassword,
                              obscure: true,
                              palceholder: "Password",
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            child: myTextField(
                              controller:
                                  forgotController.confirmNewPasswordController,
                              validator: (value) {
                                forgotController.validatePassword();
                                return forgotController
                                    .confirmPasswordError.value;
                              },
                              keyboardType: TextInputType.visiblePassword,
                              obscure: true,
                              palceholder: "Confirm Password",
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ContinueButton(
                      getController: forgotController,
                      onPress: () async {
                        if (_formKey.currentState!.validate()) {
                          // Proceed with form submission
                          print("herere /");
                          await forgotController.submit();
                        } else {
                          forgotController.changeIsLoading(false);
                        }
                        return true;
                      },
                      child: Text(
                        "Continue",
                        style: TextStyle(color: Colors.white, fontSize: 16),
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
