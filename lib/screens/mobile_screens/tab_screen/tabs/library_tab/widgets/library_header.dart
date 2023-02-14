import 'package:flutter/material.dart';
import 'package:music_app/utils/app_colors.dart';

class LibraryHeader extends StatelessWidget {
  final Widget userImageWidget;
  const LibraryHeader({Key? key, required this.userImageWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text(
        "Library",
        style: TextStyle(
            color: AppColor.onPrimaryColor,
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
            height: 32.0 / 24.0),
      ),
      subtitle: Text(
        "Feel free to edit to your liking",
        style: TextStyle(
            color: AppColor.onPrimaryColor.withOpacity(0.6),
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            height: 19.0 / 14.0),
      ),
      trailing: userImageWidget,
    );
  }
}
