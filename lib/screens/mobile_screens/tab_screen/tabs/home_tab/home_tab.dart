import 'package:flutter/material.dart';
import 'package:music_app/screens/mobile_screens/tab_screen/tabs/home_tab/widgets/home_header.dart';
import 'package:music_app/screens/mobile_screens/tab_screen/tabs/home_tab/widgets/home_playlist_list.dart';
import 'package:music_app/utils/app_colors.dart';
import 'package:music_app/view_models/track_view_model.dart';
import 'package:music_app/widgets/custom_track_item.dart';
import 'package:provider/provider.dart';

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
                onTextChange: (val, text) {},
                isReadOnly: true,
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
              child: Consumer<TrackViewModel>(
                builder: (context, model, child) {
                  var tracks = model.top10Tracks;
                  print(tracks);
                  return ListView.separated(
                    itemBuilder: (_, index) => CustomTrackItem(
                      track: tracks[index],
                    ),
                    itemCount: tracks.length,
                    separatorBuilder: (_, index) => const SizedBox(
                      height: 16.0,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
