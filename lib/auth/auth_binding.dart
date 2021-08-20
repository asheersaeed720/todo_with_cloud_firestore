import 'package:get/get.dart';
import 'package:todo_with_cloud_firestore/auth/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}
