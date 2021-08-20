import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_with_cloud_firestore/admin/view/dashboard_screen.dart';
import 'package:todo_with_cloud_firestore/auth/auth_controller.dart';
import 'package:todo_with_cloud_firestore/auth/view/login_screen.dart';
import 'package:todo_with_cloud_firestore/home/view/home_screen.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _authController = Get.find<AuthController>();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _authController.getUserData();
      var data = _authController.userData;
      if (data.isEmpty) {
        Get.offAndToNamed(LogInScreen.routeName);
      } else {
        if (data['email'] == 'ashirsaeed111@gmail.com') {
          Get.offAndToNamed(DashboardScreen.routeName);
        } else {
          Get.offAndToNamed(HomeScreen.routeName);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
