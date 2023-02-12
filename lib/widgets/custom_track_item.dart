import 'package:flutter/material.dart';
import 'package:music_app/repositories/global_repo.dart';
import 'package:music_app/screens/mobile_screens/play/play_screen.dart';

import '../models/db_models/track.dart';
import '../utils/constants/app_colors.dart';
import 'cached_image_widget.dart';

class CustomTrackItem extends StatelessWidget {
  final Track track;
  final Widget trailingWidget;

  const CustomTrackItem({Key? key, required this.track, required this.trailingWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => PlayScreen(track: track,)));
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 56,
          height: 56,
          child: CachedImageWidget(imageURL: track.imageURL, border: 8,),
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
          future: GlobalRepo.getInstance.getArtistById(track.artistId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var artist = snapshot.data!;
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
        trailing: trailingWidget
      ),
    );
  }
}
