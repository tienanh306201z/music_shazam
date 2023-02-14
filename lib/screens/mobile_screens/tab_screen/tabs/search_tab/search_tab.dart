import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_app/models/db_models/playlist.dart';
import 'package:music_app/models/db_models/track.dart';
import 'package:music_app/screens/mobile_screens/tab_screen/tabs/search_tab/widgets/search_header.dart';
import 'package:music_app/utils/app_colors.dart';
import 'package:music_app/view_models/playlist_view_model.dart';
import 'package:music_app/view_models/track_view_model.dart';
import 'package:music_app/widgets/custom_playlist_item.dart';
import 'package:music_app/widgets/custom_search_bar.dart';
import 'package:provider/provider.dart';

import '../../../../../widgets/custom_track_item.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final _controller = TextEditingController(text: "");

  final _listRecommendation = [
    "waiting",
    "đi về nhà",
    "đã lỡ yêu em nhiều",
    "âm thầm bên em",
    "suýt nữa thì",
    "đứa nào làm em buồn"
  ];

  var _containText = false;

  var tracks = <Track>[];
  var playLists = <AppPlaylist>[];

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
                          tracks = Provider.of<TrackViewModel>(context,
                                  listen: false)
                              .getSearchedTracks(_controller.text);
                          playLists = Provider.of<PlaylistViewModel>(context,
                                  listen: false)
                              .getSearchedPlaylists(_controller.text);
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

  Widget _searchTrackListSection() {
    return tracks.isEmpty
        ? const SizedBox()
        : ListView.separated(
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
  }

  Widget _searchPlaylistSection() {
    return tracks.isEmpty
        ? const SizedBox()
        : ListView.separated(
            itemBuilder: (_, index) => CustomPlaylistItem(
              playlist: playLists[index],
            ),
            itemCount: playLists.length,
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
              onTextChange: (containText, text) {
                setState(() {
                  _containText = containText;
                  tracks = Provider.of<TrackViewModel>(context, listen: false)
                      .getSearchedTracks(text);
                  playLists =
                      Provider.of<PlaylistViewModel>(context, listen: false)
                          .getSearchedPlaylists(text);
                });
              },
              controller: _controller,
              isReadOnly: false,
            ),
            const SizedBox(
              height: 24.0,
            ),
            _containText ? _searchTrackListSection() : _recommendationSection(),
            _containText ? _searchPlaylistSection() : const SizedBox()
          ],
        ),
      ),
    );
  }
}
