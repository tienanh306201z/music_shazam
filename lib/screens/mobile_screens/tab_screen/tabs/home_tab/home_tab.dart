import 'package:flutter/material.dart';
import 'package:music_app/screens/mobile_screens/tab_screen/tabs/home_tab/widgets/home_header.dart';
import 'package:music_app/screens/mobile_screens/tab_screen/tabs/home_tab/widgets/home_playlist_list.dart';
import 'package:music_app/utils/constants/app_colors.dart';
import 'package:music_app/widgets/custom_track_item.dart';

import '../../../../../widgets/custom_search_bar.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: HomeHeader(),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomSearchBar(
                controller: TextEditingController(),
                onTextChange: (val) {},
                isReadOnly: true,
                onTap: () {},
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Trending Playlist",
                style: TextStyle(
                    color: AppColor.onPrimaryColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    height: 24.0 / 18.0),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            const HomePlaylistList(),
            const SizedBox(
              height: 24.0,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Trending Track",
                style: TextStyle(
                    color: AppColor.onPrimaryColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    height: 24.0 / 18.0),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.separated(
                itemBuilder: (_, index) => const CustomTrackItem(
                  trailingWidget: Text(
                    "3:30",
                    style: TextStyle(
                      fontSize: 16.0,
                      height: 21.0 / 16.0,
                      color: AppColor.onPrimaryColor,
                    ),
                  ),
                ),
                itemCount: 10,
                separatorBuilder: (_, index) => const SizedBox(
                  height: 16.0,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
