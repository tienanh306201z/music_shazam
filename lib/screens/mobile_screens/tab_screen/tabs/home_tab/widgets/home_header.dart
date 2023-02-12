import 'package:flutter/material.dart';
import 'package:music_app/utils/constants/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text(
        "Welcome to Muzikal!",
        style: TextStyle(
            color: AppColor.onPrimaryColor,
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
            height: 32.0 / 24.0),
      ),
      subtitle: Text(
        "What do you feel like today?",
        style: TextStyle(
            color: AppColor.onPrimaryColor.withOpacity(0.6),
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            height: 19.0 / 14.0),
      ),
      trailing: Container(
        height: 40.0,
        width: 40.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Colors.blueGrey.shade200),
        child: const Icon(
          Icons.person,
          size: 20.0,
          color: Colors.grey,
        ),
      ),
    );
  }
}
