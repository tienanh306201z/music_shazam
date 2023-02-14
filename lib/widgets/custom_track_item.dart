import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_app/models/db_models/artist.dart';
import 'package:music_app/navigations/app_nav_host.dart';

import '../models/db_models/track.dart';
import '../repositories/global_repo.dart';
import '../utils/app_colors.dart';
import 'cached_image_widget.dart';

class CustomTrackItem extends StatelessWidget {
  final Track track;

  const CustomTrackItem({Key? key, required this.track}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.playScreen.name, arguments: {"track": track});
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: SizedBox(
          width: 56,
          height: 56,
          child: CachedImageWidget(imageURL: track.imageURL, border: 8, width: 56,),
        ),
        title: Text(
          track.name,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            height: 21.0 / 16.0,
            color: AppColor.onPrimaryColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle:  FutureBuilder(
          future: GlobalRepo.getInstance.getArtistById(track.artistId ?? ""),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var artist = snapshot.data! as AppArtist;
              return Text(
                artist.name,
                style: TextStyle(
                  fontSize: 12.0,
                  height: 16.0 / 12.0,
                  color: AppColor.onPrimaryColor.withOpacity(0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            } else {
              return Text(
                "V/A",
                style: TextStyle(
                  fontSize: 12.0,
                  height: 16.0 / 12.0,
                  color: AppColor.onPrimaryColor.withOpacity(0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            }
          },
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
