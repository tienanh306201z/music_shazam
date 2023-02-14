import 'package:flutter/material.dart';
import 'package:music_app/utils/app_colors.dart';

class SignInHeader extends StatelessWidget {
  const SignInHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back_outlined, color: AppColor.onPrimaryColor,),
      ),
      title: const Text(
        "Sign in",
        style: TextStyle(
            color: AppColor.onPrimaryColor,
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
            height: 32.0 / 24.0),
      ),
      // subtitle: Text(
      //   "Feel free to edit to your liking",
      //   style: TextStyle(
      //       color: AppColor.onPrimaryColor.withOpacity(0.6),
      //       fontSize: 14.0,
      //       fontWeight: FontWeight.w600,
      //       height: 19.0 / 14.0),
      // ),
    );
  }
}
