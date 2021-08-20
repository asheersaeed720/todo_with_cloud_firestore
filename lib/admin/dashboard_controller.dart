import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  CollectionReference _reference = FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot<Object?>> getAllUsers(uid) {
    return _reference.where('uid', isNotEqualTo: uid).snapshots();
  }

  activeUser(String id) {
    _reference.doc(id).update({
      "is_active": true,
    });
  }

  dectiveUser(String id) {
    _reference.doc(id).update({
      "is_active": false,
    });
  }
}
