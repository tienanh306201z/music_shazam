import 'package:flutter/material.dart';

import '../../../../../../utils/app_colors.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text(
          "Search",
          style: TextStyle(
              color: AppColor.onPrimaryColor,
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              height: 32.0 / 24.0),
        ),
        subtitle: Text(
          "What do you want to listen to?",
          style: TextStyle(
              color: AppColor.onPrimaryColor.withOpacity(0.6),
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              height: 19.0 / 14.0),
        ),
        trailing: GestureDetector(
          onTap: () {},
          child: const Icon(
            Icons.settings_rounded,
            size: 30,
            color: AppColor.onPrimaryColor,
          ),
        ));
  }
}
