import 'package:flutter/material.dart';
import 'package:music_app/utils/app_colors.dart';
import 'package:music_app/view_models/playlist_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../../../navigations/app_nav_host.dart';
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
            child: CachedImageWidget(imageURL: imageURL, border: 16, width: 200,),
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
                  Navigator.of(context).pushNamed(AppRoutes.playlistScreen.name, arguments: playlist);
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
