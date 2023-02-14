import 'package:flutter/material.dart';
import 'package:music_app/utils/app_colors.dart';

class GeneralHeader extends StatelessWidget {
  final String title;
  final Function? onTap;
  const GeneralHeader({Key? key, required this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: InkWell(
        onTap: () {
          onTap?.call();
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back_outlined, color: AppColor.onPrimaryColor,),
      ),
      title: Text(
        title,
        style: const TextStyle(
            color: AppColor.onPrimaryColor,
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
            height: 32.0 / 24.0),
      ),
    );
  }
}
