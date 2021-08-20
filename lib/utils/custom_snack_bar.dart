import 'package:flutter/material.dart';
import 'package:get/get.dart';

customSnackBar(titleTxt, msg, {color: Colors.red}) {
  Get.snackbar(
    '$titleTxt',
    "$msg",
    margin: EdgeInsets.all(0),
    backgroundColor: color,
    colorText: Colors.white,
    icon: Icon(
      Icons.info,
      color: Colors.white,
    ),
    snackPosition: SnackPosition.BOTTOM,
    snackStyle: SnackStyle.GROUNDED,
    shouldIconPulse: true,
  );
}
