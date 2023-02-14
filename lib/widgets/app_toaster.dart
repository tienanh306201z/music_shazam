import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oktoast/oktoast.dart';

import '../utils/asset_paths.dart';

enum AppToasterType { success, failed, warning, info }

class AppToaster {
  static void showToast(
      {required BuildContext context,
        required String msg,
        required AppToasterType type}) {
    try {
      Color backgroundColor = Color(0xFFE4F0FB);
      Color textColor = Color(0xFF2183DF);
      String iconPath = AssetPaths.iconPath.getInfoIconPath;
      switch (type) {
        case AppToasterType.failed:
          backgroundColor = Color(0xFFFCE4E3);
          textColor = Color(0xFFE31E18);
          iconPath = AssetPaths.iconPath.getWarningIconPath;
          break;
        case AppToasterType.info:
          backgroundColor = Color(0xFFE4F0FB);
          textColor = Color(0xFF2183DF);
          iconPath = AssetPaths.iconPath.getInfoIconPath;
          break;
        case AppToasterType.success:
          backgroundColor = Color(0xFFEBFAF5);
          textColor = Color(0xFF00C17C);
          iconPath = AssetPaths.iconPath.getCheckedIconPath;
          break;
        case AppToasterType.warning:
          backgroundColor = Color(0xFFFDF8EF);
          textColor = Color(0xFFEBAD34);
          iconPath = AssetPaths.iconPath.getAlertIconPath;
          break;
        default:
      }
      Widget toast = Container(
        constraints: const BoxConstraints(minWidth: 200, maxWidth: 300),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: backgroundColor,
            boxShadow: const [
              BoxShadow(
                  blurRadius: 2,
                  color: Color(0xFFE5E5E5),
                  spreadRadius: 0,
                  offset: Offset(0, 1))
            ]),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(iconPath, width: 20, color: textColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(msg,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );
      showToastWidget(
        Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: toast,
        ),
        position: ToastPosition.center,
        context: context,
      );
    } catch (e) {
      // switch (type) {
      //   case AppToasterType.failed:
      //     showToastError(msg);
      //     break;
      //   case AppToasterType.info:
      //     showToastInfo(msg);
      //     break;
      //   case AppToasterType.success:
      //     showToastSuccess(msg);
      //     break;
      //   case AppToasterType.warning:
      //     showToastWarning(msg);
      //     break;
      //   default:
      // }
    }
  }
}

// void showToastSuccess(String msg, { int delay = 1 }) {
//   Fluttertoast.cancel();
//   Fluttertoast.showToast(
//     msg: msg,
//     timeInSecForIosWeb: delay,
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.CENTER,
//     backgroundColor: Color(0xFFEBFAF5),
//     textColor: Color(0xFF00C17C),
//     fontSize: 16.0,
//   );
// }
//
// void showToastError(String msg) {
//   Fluttertoast.cancel();
//   Fluttertoast.showToast(
//     msg: msg,
//     timeInSecForIosWeb: 1,
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.CENTER,
//     backgroundColor: Color(0xFFFDF8EF),
//     textColor: Color(0xFFEBAD34),
//     fontSize: 16.0,
//   );
// }
//
// void showToastWarning(String msg) {
//   Fluttertoast.cancel();
//   Fluttertoast.showToast(
//     msg: msg,
//     timeInSecForIosWeb: 1,
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.CENTER,
//     backgroundColor: Colors.yellow[200],
//     textColor: Color(0xFF2183DF),
//     fontSize: 16.0,
//   );
// }
//
// void showToastInfo(String msg) {
//   Fluttertoast.cancel();
//   Fluttertoast.showToast(
//     msg: msg,
//     timeInSecForIosWeb: 1,
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.CENTER,
//     backgroundColor: Color(0xFFE4F0FB),
//     textColor: Colors.white,
//     fontSize: 16.0,
//   );
// }