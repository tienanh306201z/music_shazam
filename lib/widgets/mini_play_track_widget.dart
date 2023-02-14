import 'package:flutter/material.dart';
import 'package:music_app/models/db_models/artist.dart';
import 'package:music_app/navigations/app_nav_host.dart';
import 'package:music_app/utils/app_colors.dart';
import 'package:music_app/view_models/play_view_model.dart';
import 'package:provider/provider.dart';

import '../repositories/global_repo.dart';
import '../utils/asset_paths.dart';
import 'cached_image_widget.dart';

class MiniPlayTrackWidget extends StatefulWidget {
  const MiniPlayTrackWidget({Key? key}) : super(key: key);

  @override
  State<MiniPlayTrackWidget> createState() => _MiniPlayTrackWidgetState();
}

class _MiniPlayTrackWidgetState extends State<MiniPlayTrackWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayViewModel>(
      builder: (context, model, child) {
        var track = model.currentTrack;
        var progressBar = model.progressBar;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (progressBar != null)
              LinearProgressIndicator(
                value: (model.progressBar!.buffered.inMilliseconds.isInfinite || model.progressBar!.buffered.inMilliseconds.isNaN
                        ? 0
                        : model.progressBar!.current.inMilliseconds) *
                    1.0 /
                    (model.progressBar!.total.inMilliseconds.isInfinite || model.progressBar!.total.inMilliseconds.isNaN
                        ? 1
                        : model.progressBar!.total.inMilliseconds),
                backgroundColor: AppColor.primaryColor.withOpacity(0.4),
                color: AppColor.onPrimaryColor,
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 60,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                AppColor.primaryColor.withOpacity(0.4),
                const Color(0xFF1A0A31)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.playScreen.name, arguments: {
                        "track": track,
                        "isInit": false,
                      });
                    },
                    child: Row(
                      children: [
                        CachedImageWidget(
                          imageURL: track?.imageURL ?? "",
                          width: 40,
                          height: 40,
                          border: 8,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        SizedBox(
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                track?.name ?? "",
                                style: const TextStyle(
                                  color: AppColor.onPrimaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              FutureBuilder(
                                future: GlobalRepo.getInstance
                                    .getArtistById(track?.artistId ?? ""),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    var artist = snapshot.data as AppArtist?;
                                    return Text(
                                      artist?.name ?? "",
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        height: 16.0 / 12.0,
                                        color: AppColor.onPrimaryColor
                                            .withOpacity(0.6),
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
                                        color: AppColor.onPrimaryColor
                                            .withOpacity(0.6),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      if (model.playButton == ButtonState.paused ||
                          model.playButton == ButtonState.loading ||
                          model.playButton == null)
                        InkWell(
                          onTap: model.play,
                          child: Image.asset(
                            AssetPaths.iconPath.getPlayIconPath,
                            width: 20,
                          ),
                        ),
                      if (model.playButton == ButtonState.playing)
                        InkWell(
                          onTap: model.pause,
                          child: Image.asset(
                            AssetPaths.iconPath.getPauseIconPath,
                            width: 20,
                          ),
                        ),
                      const SizedBox(
                        width: 24,
                      ),
                      InkWell(
                        onTap: () {
                          if (model.playlist != null) {
                            model.onNextSongButtonPressed();
                          } else {
                            model.onNextRandomTrackPressed();
                          }
                        },
                        child: Image.asset(
                          AssetPaths.iconPath.getNextIconPath,
                          width: 20,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
