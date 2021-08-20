import 'package:flutter/material.dart';

void showAlertDialog(context, String title, String message, onPressed) {
  AlertDialog alertDialog = AlertDialog(
    title: Text('$title'),
    content: Text('$message'),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          'No',
          style: TextStyle(color: Colors.black54),
        ),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.red[600]),
        onPressed: onPressed,
        child: Text(
          'Yes',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ],
  );
  showDialog(context: context, builder: (_) => alertDialog);
}
