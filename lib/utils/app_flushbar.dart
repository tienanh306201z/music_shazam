import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

enum AppSnackBarType {
  success, failed, warning, info
}

class AppSnackBar {
  static void showSnackBar(BuildContext context, String msg, AppSnackBarType type) {
    IconData iconData = Icons.info_outline;
    Color? color = Colors.blue[300];

    switch (type) {
      case AppSnackBarType.info:
        iconData = Icons.info_outline;
        color = Colors.blue[300];
        break;
      case AppSnackBarType.success:
        iconData = Icons.check;
        color = Colors.green[300];
        break;
      case AppSnackBarType.warning:
        iconData = Icons.warning;
        color = Colors.yellow[300];
        break;
      case AppSnackBarType.failed:
        iconData = Icons.error;
        color = Colors.red[300];
        break;
    }

    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      message: msg,
      icon: Icon(
        iconData,
        size: 28.0,
        color: color,
      ),
      duration: const Duration(seconds: 1),
      leftBarIndicatorColor: color,
    ).show(context);
  }
}