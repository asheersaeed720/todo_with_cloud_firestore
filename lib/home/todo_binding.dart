import 'package:get/get.dart';
import 'package:todo_with_cloud_firestore/home/todo_controller.dart';

class TodoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TodoController());
  }
}
