import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_app/screens/mobile_screens/tab_screen/tabs/search_tab/widgets/search_header.dart';
import 'package:music_app/utils/constants/app_colors.dart';
import 'package:music_app/widgets/custom_search_bar.dart';

import '../../../../../widgets/custom_track_item.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final _controller = TextEditingController(text: "");

  final _listRecommendation = [
    "love me like you do",
    "perfect",
    "can't take my eyes off of you",
    "you're beautiful",
    "biet iu 1 nguoi",
    "anh khong the gi dau anh lam"
  ];

  var _containText = false;

  Widget _recommendationSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recommend for you",
          style: TextStyle(
            color: AppColor.onPrimaryColor,
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Wrap(
            spacing: 10.0,
            children: _listRecommendation
                .map((e) => ActionChip(
                      onPressed: () {
                        setState(() {
                          _controller.text = e;
                          _containText = true;
                        });
                      },
                      label: Text(
                        e,
                        style: const TextStyle(
                            fontSize: 12.0, color: AppColor.onSurfaceColor),
                      ),
                      backgroundColor: AppColor.surfaceColor,
                      avatar: const Icon(
                        FontAwesomeIcons.arrowTrendUp,
                        size: 12,
                        color: AppColor.onSurfaceColor,
                      ),
                    ))
                .toList())
      ],
    );
  }

  Widget _searchListSection() {
    return ListView.separated(
      itemBuilder: (_, index) => CustomTrackItem(
          trailingWidget: PopupMenuButton(
        offset: const Offset(0, 50),
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.more_vert,
          color: AppColor.onPrimaryColor.withOpacity(0.6),
          size: 28,
        ),
        itemBuilder: (ctx) => [
          PopupMenuItem(
            child: Row(
              children: const [
                Icon(
                  Icons.key_rounded,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Change Password",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      )),
      itemCount: 10,
      separatorBuilder: (_, index) => const SizedBox(
        height: 16.0,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchHeader(),
            const SizedBox(
              height: 16.0,
            ),
            CustomSearchBar(
              onTextChange: (containText) {
                setState(() {
                  _containText = containText;
                });
              },
              controller: _controller,
              isReadOnly: false,
              onTap: () {},
            ),
            const SizedBox(
              height: 24.0,
            ),
            _containText ? _searchListSection() : _recommendationSection()
          ],
        ),
      ),
    );
  }
}
