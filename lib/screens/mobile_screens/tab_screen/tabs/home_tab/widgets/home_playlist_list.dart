import 'package:flutter/material.dart';
import 'package:music_app/screens/mobile_screens/play/play_screen.dart';
import 'package:music_app/screens/mobile_screens/playlist/playlist_screen.dart';
import 'package:music_app/utils/constants/app_colors.dart';
import 'package:music_app/view_models/playlist_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../../../widgets/cached_image_widget.dart';

class HomePlaylistList extends StatelessWidget {
  const HomePlaylistList({Key? key}) : super(key: key);

  Widget _homePlaylistItem(String imageURL, String title, String subTitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: CachedImageWidget(imageURL: imageURL, border: 16,),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              height: 21.0 / 16.0,
              color: AppColor.onPrimaryColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subTitle,
            style: TextStyle(
              fontSize: 12.0,
              height: 16.0 / 12.0,
              color: AppColor.onPrimaryColor.withOpacity(0.6),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistViewModel>(
      builder: (context, model, child) {
        var playlists = model.playlists;
        return SizedBox(
          height: 260,
          child: ListView.builder(
            itemBuilder: (_, index) {
              var playlist = playlists[index];
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => PlaylistScreen(playlist: playlist)));
                },
                child: _homePlaylistItem(playlist.imageURL!, playlist.name, "Playlist"),
              );
            },
            itemCount: playlists.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
          ),
        );
      },
    );
  }
}
