import 'package:flutter/material.dart';

import '../utils/constants/app_colors.dart';

class CustomTrackItem extends StatelessWidget {
  final Widget trailingWidget;

  const CustomTrackItem({Key? key, required this.trailingWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(8)),
      ),
      title: const Text(
        "Tardes de Melancolía",
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          height: 21.0 / 16.0,
          color: AppColor.onPrimaryColor,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        "Indios",
        style: TextStyle(
          fontSize: 12.0,
          height: 16.0 / 12.0,
          color: AppColor.onPrimaryColor.withOpacity(0.6),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: trailingWidget
    );
  }
}
