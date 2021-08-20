import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:todo_with_cloud_firestore/auth/auth_controller.dart';
import 'package:todo_with_cloud_firestore/auth/view/login_screen.dart';
import 'package:todo_with_cloud_firestore/utils/input_decoration.dart';
import 'package:todo_with_cloud_firestore/widgets/custom_button.dart';
import 'package:todo_with_cloud_firestore/widgets/loading_indicator.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/sign-up';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> _formKeySignup = GlobalKey<FormState>();

  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKeySignup,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEmailTextField(),
                  const SizedBox(height: 20.0),
                  const Text('Password'),
                  const SizedBox(height: 10.0),
                  _buildPasswordTextField(),
                  const SizedBox(height: 20.0),
                  const Text('Confirm Password'),
                  const SizedBox(height: 10.0),
                  _buildConfirmPasswordTextField(),
                  const SizedBox(height: 22),
                  Obx(
                    () => _authController.isLoading.value
                        ? LoadingIndicator()
                        : CustomButton(
                            width: double.infinity,
                            btnTxt: 'Signup',
                            onPressed: () async {
                              if (_formKeySignup.currentState!.validate()) {
                                _formKeySignup.currentState!.save();
                                FocusScopeNode currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                _authController.signUpUser();
                              }
                            },
                          ),
                  ),
                  const SizedBox(height: 32.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Alreadu have an account'),
                      const SizedBox(width: 8.0),
                      InkWell(
                        onTap: () {
                          Get.offNamed(LogInScreen.routeName);
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      onChanged: (value) {
        _authController.userModel.update((val) {
          val!.email = value.trim();
        });
      },
      validator: (value) => value!.isEmpty ? "Required" : null,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: buildTextFieldInputDecoration(context, txt: 'Email'),
    );
  }

  Widget _buildPasswordTextField() {
    return Obx(
      () => TextFormField(
        onChanged: (value) {
          _authController.userModel.update((val) {
            val!.password = value;
          });
        },
        obscureText: _authController.obscureText.value,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Required';
          } else if (_authController.userModel.value.password.length < 6) {
            return 'too Short';
          }
          return null;
        },
        keyboardType: TextInputType.visiblePassword,
        decoration: buildPasswordInputDecoration(
          context,
          txt: 'Password',
          suffixIcon: GestureDetector(
            onTap: () {
              _authController.obscureText.toggle();
            },
            child: Icon(
              _authController.obscureText.value ? Icons.visibility : Icons.visibility_off,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordTextField() {
    return Obx(
      () => TextFormField(
        onChanged: (value) {
          _authController.userModel.update((val) {
            val!.confirmPassword = value;
          });
        },
        obscureText: _authController.obscureText.value,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Required';
          } else if (_authController.userModel.value.password !=
              _authController.userModel.value.confirmPassword) {
            return 'please match password';
          }
          return null;
        },
        keyboardType: TextInputType.visiblePassword,
        decoration: buildPasswordInputDecoration(
          context,
          txt: 'Confirm password',
          suffixIcon: GestureDetector(
            onTap: () {
              _authController.obscureText.toggle();
            },
            child: new Icon(
              _authController.obscureText.value ? Icons.visibility : Icons.visibility_off,
            ),
          ),
        ),
      ),
    );
  }
}
