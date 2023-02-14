import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/db_models/playlist.dart';
import '../navigations/app_nav_host.dart';
import '../utils/app_colors.dart';
import 'cached_image_widget.dart';

class CustomPlaylistItem extends StatelessWidget {
  final AppPlaylist playlist;

  const CustomPlaylistItem({Key? key, required this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.playlistScreen.name, arguments: playlist);
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: SizedBox(
          width: 56,
          height: 56,
          child: CachedImageWidget(
            imageURL: playlist.imageURL ?? "",
            border: 8,
            width: 56,
          ),
        ),
        title: Text(
          playlist.name,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            height: 21.0 / 16.0,
            color: AppColor.onPrimaryColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "Playlist",
          style: TextStyle(
            fontSize: 12.0,
            height: 16.0 / 12.0,
            color: AppColor.onPrimaryColor.withOpacity(0.6),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(
          FontAwesomeIcons.play,
          color: AppColor.onPrimaryColor,
          size: 16,
        ),
      ),
    );
  }
}
