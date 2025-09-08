import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ToastService {
  showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
      ));
  }

  show(String message) {
    Fluttertoast.showToast(msg: message, backgroundColor: Colors.black);
  }

  showLong(String message) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.black,
        toastLength: Toast.LENGTH_LONG);
  }

  showInCenter(String message) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.black,
        gravity: ToastGravity.CENTER);
  }
}
