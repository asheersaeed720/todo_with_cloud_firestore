import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_with_cloud_firestore/admin/dashboard_binding.dart';
import 'package:todo_with_cloud_firestore/admin/view/dashboard_screen.dart';
import 'package:todo_with_cloud_firestore/auth/auth_binding.dart';
import 'package:todo_with_cloud_firestore/auth/view/auth_screen.dart';
import 'package:todo_with_cloud_firestore/auth/view/login_screen.dart';
import 'package:todo_with_cloud_firestore/auth/view/signup_screen.dart';
import 'package:todo_with_cloud_firestore/home/todo_binding.dart';
import 'package:todo_with_cloud_firestore/home/view/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.lightBlue,
          errorColor: Colors.red[800],
          backgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: AuthScreen.routeName,
        getPages: [
          GetPage(name: AuthScreen.routeName, page: () => AuthScreen(), binding: AuthBinding()),
          GetPage(
            name: LogInScreen.routeName,
            page: () => LogInScreen(),
            binding: AuthBinding(),
          ),
          GetPage(name: SignUpScreen.routeName, page: () => SignUpScreen(), binding: AuthBinding()),
          GetPage(
            name: HomeScreen.routeName,
            page: () => HomeScreen(),
            bindings: [AuthBinding(), TodoBinding()],
          ),
          GetPage(
            name: DashboardScreen.routeName,
            page: () => DashboardScreen(),
            bindings: [AuthBinding(), DashboardBinding()],
          ),
        ],
      );
}
