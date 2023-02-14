import 'package:flutter/material.dart';

import '../../../../../../utils/app_colors.dart';

class YourTrackHeader extends StatelessWidget {
  final Widget trailingWidget;
  const YourTrackHeader({Key? key, required this.trailingWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text(
        "Your track",
        style: TextStyle(
            color: AppColor.onPrimaryColor,
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
            height: 32.0 / 24.0),
      ),
      subtitle: Text(
        "Upload all you want",
        style: TextStyle(
            color: AppColor.onPrimaryColor.withOpacity(0.6),
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            height: 19.0 / 14.0),
      ),
      trailing: trailingWidget,
    );
  }
}