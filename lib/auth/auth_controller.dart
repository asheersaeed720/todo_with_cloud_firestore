import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_with_cloud_firestore/auth/model/user.dart';
import 'package:todo_with_cloud_firestore/auth/view/auth_screen.dart';
import 'package:todo_with_cloud_firestore/utils/custom_snack_bar.dart';
import 'package:encrypt/encrypt.dart' as EncryptPack;

class AuthController extends GetxController {
  RxBool obscureText = true.obs;

  RxBool isLoading = false.obs;

  Rx<UserModel> userModel = UserModel().obs;

  RxMap userData = Map().obs;

  CollectionReference _reference = FirebaseFirestore.instance.collection('users');

  @override
  void onInit() {
    ever(userModel, (val) {
      print(val);
    });
    super.onInit();
  }

  void loginUser() async {
    isLoading.value = true;
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "${userModel.value.email}",
        password: "${userModel.value.password}",
      );
      if (userCredential.user != null) {
        _reference.doc('${userCredential.user!.uid}').get().then((value) {
          if (value['is_active']) {
            var encryptedPass = encryptPass();
            Map<String, dynamic> data = {
              "uid": "${userCredential.user?.uid}",
              "email": "${userModel.value.email}",
              "password": "$encryptedPass",
            };
            GetStorage().write('user', data);
            getUserData();
            Get.offAndToNamed(AuthScreen.routeName);
          } else {
            customSnackBar('Error', 'You are Banned');
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        customSnackBar('Error', 'No user found');
      } else if (e.code == 'wrong-password') {
        customSnackBar('Error', 'Invalid Credentail');
      }
    } catch (e) {
      print(e);
    }
    isLoading.value = false;
  }

  void signUpUser() async {
    isLoading.value = true;
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: "${userModel.value.email}",
        password: "${userModel.value.password}",
      );
      if (userCredential.user != null) {
        var encryptedPass = encryptPass();
        Map<String, dynamic> data = {
          "uid": "${userCredential.user?.uid}",
          "email": "${userModel.value.email}",
          "is_active": true,
          "password": "$encryptedPass",
        };
        _reference.doc(userCredential.user!.uid).set(data);
        GetStorage().write('user', data);
        getUserData();
        Get.offAndToNamed(AuthScreen.routeName);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        customSnackBar('Error', 'Password is too weak');
      } else if (e.code == 'email-already-in-use') {
        customSnackBar('Error', 'Email aleady exist');
      }
    } catch (e) {
      print(e);
    }
    isLoading.value = false;
  }

  getUserData() {
    userData.value = GetStorage().read('user') == null ? {} : GetStorage().read('user');
    log('$userData', name: 'userDataGotIt');
  }

  String encryptPass() {
    // final jsonString = '{"pw": "${userModel.value.password}"}';
    final key = EncryptPack.Key.fromUtf8('aass2xQ5gk56hcFpd208U0AsI8mxaaoh');
    final iv = EncryptPack.IV.fromLength(16);

    final encrypter = EncryptPack.Encrypter(EncryptPack.AES(key, mode: EncryptPack.AESMode.cbc));
    final encrypted = encrypter.encrypt('${userModel.value.password}', iv: iv);
    return encrypted.base64;
  }

  void signOutUser() async {
    await FirebaseAuth.instance.signOut();
    GetStorage().remove('user');
    Get.offAndToNamed(AuthScreen.routeName);
  }
}
