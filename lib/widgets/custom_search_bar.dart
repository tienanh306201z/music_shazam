import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/app_colors.dart';
import '../view_models/home_pager_view_model.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(bool, String) onTextChange;
  final bool isReadOnly;

  const CustomSearchBar(
      {Key? key,
      required this.isReadOnly,
      required this.controller,
      required this.onTextChange})
      : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: () => Provider.of<HomePagerViewModel>(context, listen: false).navigateToPage(1, context),
      controller: widget.controller,
      onChanged: (val) {
        widget.onTextChange(val != "" ? true : false, val);
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        hintText: "Search song, playlist, artist...",
        prefixIcon: const Icon(Icons.search),
        prefixIconColor: AppColor.onSurfaceColor.withOpacity(0.6),
        hintStyle: TextStyle(color: AppColor.onSurfaceColor.withOpacity(0.6)),
        filled: true,
        fillColor: AppColor.surfaceColor.withOpacity(0.6),
        suffixIcon: widget.controller.text != ""
            ? GestureDetector(
                onTap: () {
                  widget.onTextChange.call(false, "");
                  setState(() {
                    widget.controller.clear();
                  });
                },
                child: Icon(Icons.close_sharp,
                    color: AppColor.onSurfaceColor.withOpacity(0.6)))
            : null,
        suffixIconColor: AppColor.onSurfaceColor.withOpacity(0.6),
      ),
      style: const TextStyle(color: AppColor.onSurfaceColor),
      readOnly: widget.isReadOnly,
    );
  }
}
