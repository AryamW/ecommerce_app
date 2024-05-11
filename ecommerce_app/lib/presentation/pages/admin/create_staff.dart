import 'package:ecommerce_app/core/utils/roles.dart';
import 'package:ecommerce_app/domain/usecases/auth.dart';
import 'package:ecommerce_app/presentation/controllers/admin_user.dart';
import 'package:ecommerce_app/presentation/controllers/auth.dart';
import 'package:ecommerce_app/presentation/pages/auth/login.dart';
import 'package:ecommerce_app/presentation/pages/home/home.dart';
import 'package:ecommerce_app/presentation/widgets/button.dart';
import 'package:ecommerce_app/presentation/widgets/myTextField.dart';
import 'package:ecommerce_app/presentation/widgets/roleBasedAccessControlWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RegisterAdminPage extends StatelessWidget {
  // TextEditingController _emailController = TextEditingController();
  // TextEditingController _firstnameController = TextEditingController();
  // TextEditingController _lastnameController = TextEditingController();
  // TextEditingController _passwordController = TextEditingController();
  final registerController = Get.find<AdminUsersController>();
  final _formKey = GlobalKey<FormState>();

  RegisterAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AccessControlWidget(
      allowedRole: Roles.ADMIN,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          body: Container(
            alignment: Alignment.center,
            color: Theme.of(context).colorScheme.primary,
            child: SingleChildScrollView(
              child: Container(
                width: 800,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const backButton(),
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
                              controller:
                                  registerController.firstNameController,
                              validator: (value) {
                                registerController.validateFirstName();
                                return registerController.firstNameError.value;
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
                              controller: registerController.lastNameController,
                              validator: (value) {
                                registerController.validateLastName();
                                return registerController.lastNameError.value;
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
                              controller: registerController.emailController,
                              validator: (value) {
                                registerController.validateEmail();
                                return registerController.emailError.value;
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
                            controller: registerController.passwordController,
                            validator: (value) {
                              registerController.validatePassword();
                              return registerController.passwordError.value;
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
                            controller: registerController.confirmController,
                            validator: (value) {
                              registerController.validateConfirm();
                              return registerController.confirmError.value;
                            },
                            keyboardType: TextInputType.visiblePassword,
                            obscure: true,
                            palceholder: "Confirm Password",
                          )),
                          const SizedBox(
                            height: 15,
                          ),
                          ContinueButton(
                            onPress: () {
                              if (_formKey.currentState!.validate()) {
                                registerController.submitForm();
                              }
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
