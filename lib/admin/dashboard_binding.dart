import 'package:get/get.dart';
import 'package:todo_with_cloud_firestore/admin/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
  }
}
