import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TodoController extends GetxController {
  CollectionReference _reference = FirebaseFirestore.instance.collection('todos');

  final isUpdate = false.obs;

  Stream<QuerySnapshot<Object?>> findAllTodos(uid) {
    return _reference.where("uid", isEqualTo: uid).snapshots();
  }

  addTodo(uid, titleTxt) async {
    await _reference.add({
      "uid": "$uid",
      "title": "$titleTxt",
    });
  }

  updateTodo(String id, uid, titleTxt) {
    _reference.doc(id).update({
      "uid": "$uid",
      "title": "$titleTxt",
    });
  }

  deleteTodo(String id) {
    _reference.doc(id).delete();
  }
}
