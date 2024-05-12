import 'package:ecommerce_app/domain/usecases/auth.dart';
import 'package:ecommerce_app/presentation/controllers/auth.dart';
import 'package:ecommerce_app/presentation/pages/auth/login.dart';
import 'package:ecommerce_app/presentation/pages/home/home.dart';
import 'package:ecommerce_app/presentation/widgets/button.dart';
import 'package:ecommerce_app/presentation/widgets/myTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  // TextEditingController _emailController = TextEditingController();
  // TextEditingController _firstnameController = TextEditingController();
  // TextEditingController _lastnameController = TextEditingController();
  // TextEditingController _passwordController = TextEditingController();
  final registerConroller = Get.put(RegisterConroller());
  final _formKey = GlobalKey<FormState>();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          leading: const backButton(
            nextPageName: "/login",
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          height: double.infinity,
          color: Theme.of(context).colorScheme.primary,
          child: Container(
            width: 800,
            padding: const EdgeInsets.all(20.0),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (Get.arguments != null)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                Container(
                                    color: Colors.red.withOpacity(0.3),
                                    alignment: Alignment.center,
                                    child: Text("${Get.arguments["message"]}",
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        )))
                              ])
                        : const SizedBox(
                            width: 0,
                            height: 0,
                          ),
                    Text("Create Account",
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary)),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            child: myTextField(
                              controller: registerConroller.firstNameController,
                              validator: (value) {
                                registerConroller.validateFirstName();
                                return registerConroller.firstNameError.value;
                              },
                              keyboardType: TextInputType.emailAddress,
                              palceholder: "First Name",
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            child: myTextField(
                              controller: registerConroller.lastNameController,
                              validator: (value) {
                                registerConroller.validateLastName();
                                return registerConroller.lastNameError.value;
                              },
                              keyboardType: TextInputType.emailAddress,
                              palceholder: "Last Name",
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            child: myTextField(
                              controller: registerConroller.emailController,
                              validator: (value) {
                                registerConroller.validateEmail();
                                return registerConroller.emailError.value;
                              },
                              keyboardType: TextInputType.emailAddress,
                              palceholder: "Email Address",
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                              child: myTextField(
                            controller: registerConroller.passwordController,
                            validator: (value) {
                              registerConroller.validatePassword();
                              return registerConroller.passwordError.value;
                            },
                            keyboardType: TextInputType.visiblePassword,
                            obscure: true,
                            palceholder: "Password",
                          )),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                              child: myTextField(
                            controller: registerConroller.confirmController,
                            validator: (value) {
                              registerConroller.validateConfirm();
                              return registerConroller.confirmError.value;
                            },
                            keyboardType: TextInputType.visiblePassword,
                            obscure: true,
                            palceholder: "Confirm Password",
                          )),

                          const SizedBox(
                            height: 15,
                          ),
                          // TextButton(
                          //   style: ButtonStyle(
                          //     padding: MaterialStateProperty.all<EdgeInsets>(
                          //         EdgeInsets.all(20)),
                          //     backgroundColor:
                          //         MaterialStateProperty.all<Color>(Color(0xFF8E6CEF)),
                          //   ),
                          //   onPressed: () => print("login"),
                          //   child:
                          // ),
                          ContinueButton(
                            getController: registerConroller,
                            onPress: () async {
                              if (_formKey.currentState!.validate()) {
                                await registerConroller.submitForm();
                                // Proceed with form submission
                                // Get.toNamed("/home");
                              } else {
                                registerConroller.changeIsLoading(false);
                              }
                              return true;
                            },
                            child: const Text(
                              "Continue",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Text(
                                "Have an Account?",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed("/login");
                                },
                                child: Text(
                                  "login",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
