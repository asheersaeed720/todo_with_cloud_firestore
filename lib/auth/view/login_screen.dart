import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_with_cloud_firestore/auth/auth_controller.dart';
import 'package:todo_with_cloud_firestore/auth/view/signup_screen.dart';
import 'package:todo_with_cloud_firestore/utils/input_decoration.dart';
import 'package:todo_with_cloud_firestore/widgets/custom_button.dart';
import 'package:todo_with_cloud_firestore/widgets/loading_indicator.dart';

class LogInScreen extends StatefulWidget {
  static const String routeName = '/login';

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  GlobalKey<FormState> _formKeyLogin = GlobalKey<FormState>();

  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKeyLogin,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 32.0),
                Text('Email'),
                const SizedBox(height: 10.0),
                _buildEmailTextField(),
                const SizedBox(height: 20.0),
                Text('Password'),
                const SizedBox(height: 10.0),
                _buildPasswordTextField(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Obx(
                  () => _authController.isLoading.value
                      ? LoadingIndicator()
                      : CustomButton(
                          btnTxt: 'Login',
                          onPressed: () {
                            if (_formKeyLogin.currentState!.validate()) {
                              _formKeyLogin.currentState!.save();
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              _authController.loginUser();
                            }
                          },
                        ),
                ),
                const SizedBox(height: 32.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account'),
                    const SizedBox(width: 8.0),
                    InkWell(
                      onTap: () {
                        Get.offNamed(SignUpScreen.routeName);
                      },
                      child: Text(
                        'Register',
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
            return 'Too short';
          }
          return null;
        },
        keyboardType: TextInputType.visiblePassword,
        decoration: buildPasswordInputDecoration(
          context,
          txt: 'Password',
          suffixIcon: GestureDetector(
            onTap: () {
              _authController.obscureText.value = !_authController.obscureText.value;
            },
            child: Icon(
              _authController.obscureText.value ? Icons.visibility : Icons.visibility_off,
            ),
          ),
        ),
      ),
    );
  }
}
