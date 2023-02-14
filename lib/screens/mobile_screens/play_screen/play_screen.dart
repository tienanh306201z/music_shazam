import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:music_app/models/db_models/artist.dart';
import 'package:music_app/models/db_models/playlist.dart';
import 'package:music_app/utils/app_colors.dart';
import 'package:music_app/utils/constants.dart';
import 'package:music_app/utils/asset_paths.dart';
import 'package:music_app/utils/extension.dart';
import 'package:music_app/view_models/play_view_model.dart';
import 'package:provider/provider.dart';

import '../../../models/db_models/app_user.dart';
import '../../../models/db_models/track.dart';
import '../../../repositories/global_repo.dart';
import '../../../view_models/user_view_model.dart';
import '../../../widgets/app_toaster.dart';
import '../karaoke_screen/karaoke_screen.dart';

final globalRepo = GlobalRepo.getInstance;

class PlayScreen extends StatefulWidget {
  const PlayScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  var _isFetchSuccessful = false;

  late final AppUser? _user;
  late final Track? _track;
  late final AppPlaylist? _playlist;
  late final bool _isPlaylist;
  late final List<Track>? _tracks;
  late final bool _isInit;

  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _track = arguments?["track"] as Track?;
      _isInit = (arguments?["isInit"] as bool?) ?? true;
      _isPlaylist = (arguments?["isPlaylist"] as bool?) ?? false;
      _playlist = arguments?["playlist"] as AppPlaylist?;
      _tracks = arguments?["tracks"] as List<Track>?;

      _user = Provider.of<UserViewModel>(context, listen: false).currentUser;

      if (_isInit) {
        if (!_isPlaylist) {
          Provider.of<PlayViewModel>(context, listen: false).init(
            _track!,
          );
        } else {
          Provider.of<PlayViewModel>(context, listen: false)
              .initPlaylist(_tracks!);
          globalRepo.updateListenCountPlaylist(_playlist!.id);
        }
      }
      setState(() {
        _isFetchSuccessful = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayViewModel>(
      builder: (context, model, child) {
        return Scaffold(
            body: _isFetchSuccessful
                ? Stack(
                    children: [
                      Container(
                        constraints: const BoxConstraints.expand(),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: NetworkImage(model.currentTrack?.imageURL ??
                              Constants().loadingImage),
                          fit: BoxFit.cover,
                        )),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            color: "#AA110929".toColor(),
                          ),
                        ),
                      ),
                      SafeArea(
                        child: PageView(
                          controller: _controller,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Icon(Icons.arrow_back,
                                                color: AppColor.onSurfaceColor),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: const Icon(
                                                Icons.playlist_add_outlined,
                                                color: AppColor.onSurfaceColor),
                                          ),
                                        ]),
                                  ),
                                  const SizedBox(height: 40.0),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: Image.network(
                                      model.currentTrack?.imageURL ??
                                          Constants().loadingImage,
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 80,
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            await FlutterShare.share(
                                                title: 'Share song',
                                                linkUrl: model.currentTrack
                                                        ?.musicLink ??
                                                    "",
                                                chooserTitle: 'Share song');
                                          },
                                          icon: const Icon(
                                            Icons.share_outlined,
                                            size: 24,
                                            color: AppColor.onPrimaryColor,
                                          )),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Text(
                                                  model.currentTrack!.name,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: "#FFFFFF".toColor(),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              model.currentTrack!.artistId !=
                                                          null &&
                                                      model.currentTrack!
                                                          .artistId!.isNotEmpty
                                                  ? FutureBuilder(
                                                      future: globalRepo
                                                          .getArtistById(model
                                                              .currentTrack!
                                                              .artistId!),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          final artist =
                                                              snapshot.data
                                                                  as AppArtist;

                                                          return Text(
                                                            artist.name,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: "99FFFFFF"
                                                                    .toColor()),
                                                          );
                                                        } else {
                                                          return const SizedBox();
                                                        }
                                                      },
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      StreamBuilder<DocumentSnapshot>(
                                        stream: globalRepo.getStreamTrackById(
                                            model.currentTrack!.id),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            var track = Track.fromMap(
                                                snapshot.data?.data()
                                                    as Map<String, dynamic>);
                                            return InkWell(
                                              onTap: () {
                                                if (_user != null) {
                                                  globalRepo
                                                      .updateFavoriteUserList(
                                                          _user!.id, track.id);
                                                  globalRepo
                                                      .updateLikedTracksIdList(
                                                          track.id);
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Image.asset(
                                                  _user != null
                                                      ? track.favoriteUserIdList
                                                              .contains(
                                                                  _user!.id)
                                                          ? AssetPaths.iconPath
                                                              .getHeartFillIconPath
                                                          : AssetPaths.iconPath
                                                              .getHeartIconPath
                                                      : AssetPaths.iconPath
                                                          .getHeartIconPath,
                                                  width: 24,
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Image.asset(
                                              AssetPaths
                                                  .iconPath.getHeartIconPath,
                                              width: 24,
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Column(
                                    children: [
                                      ProgressBar(
                                        baseBarColor: "#77FFFFFF".toColor(),
                                        bufferedBarColor: "#99FFFFFF".toColor(),
                                        progressBarColor: Colors.white,
                                        thumbColor: Colors.white,
                                        thumbRadius: 8,
                                        timeLabelTextStyle: const TextStyle(
                                            color: Colors.white),
                                        progress: model.progressBar!.current,
                                        buffered: model.progressBar?.buffered,
                                        total: model.progressBar!.total,
                                        onSeek: model.seek,
                                      ),
                                      const SizedBox(
                                        height: 60,
                                      ),
                                      SizedBox(
                                        height: 40,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                model.onShuffleButtonPressed();
                                              },
                                              child: Image.asset(
                                                shuffleImage(model),
                                                width: 28,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    if (model.playlist !=
                                                        null) {
                                                      model
                                                          .onPreviousSongButtonPressed();
                                                    } else {
                                                      model
                                                          .onPreviousRandomTrackPressed();
                                                    }
                                                  },
                                                  child: Image.asset(
                                                    AssetPaths.iconPath
                                                        .getPreviousIconPath,
                                                    width: 24,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 32,
                                                ),
                                                if (model.playButton ==
                                                        ButtonState.paused ||
                                                    model.playButton ==
                                                        ButtonState.loading ||
                                                    model.playButton == null)
                                                  InkWell(
                                                    onTap: model.play,
                                                    child: Image.asset(
                                                      AssetPaths.iconPath
                                                          .getPlayIconPath,
                                                      width: 36,
                                                    ),
                                                  ),
                                                if (model.playButton ==
                                                    ButtonState.playing)
                                                  InkWell(
                                                    onTap: model.pause,
                                                    child: Image.asset(
                                                      AssetPaths.iconPath
                                                          .getPauseIconPath,
                                                      width: 36,
                                                    ),
                                                  ),
                                                const SizedBox(
                                                  width: 32,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    if (model.playlist !=
                                                        null) {
                                                      model
                                                          .onNextSongButtonPressed();
                                                    } else {
                                                      model
                                                          .onNextRandomTrackPressed();
                                                    }
                                                  },
                                                  child: Image.asset(
                                                    AssetPaths.iconPath
                                                        .getNextIconPath,
                                                    width: 24,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            InkWell(
                                              onTap: () {
                                                model.onRepeatButtonPressed();
                                              },
                                              child: loopImage(model),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (model.currentTrack!
                                                          .beatLink !=
                                                      null &&
                                                  model.currentTrack!.beatLink!
                                                      .isNotEmpty) {
                                                if (model.isPlayBeat) {
                                                  model.init(
                                                    model.currentTrack!,
                                                  );
                                                } else {
                                                  model.init(
                                                      model.currentTrack!,
                                                      isBeatLink: true);
                                                }
                                                // model.changePlayBeat();
                                              } else {
                                                AppToaster.showToast(
                                                  context: context,
                                                  msg:
                                                      'This track does not have beat!',
                                                  type: AppToasterType.warning,
                                                );
                                              }
                                            },
                                            child: Image.asset(
                                              model.isPlayBeat
                                                  ? AssetPaths.iconPath
                                                      .getBeatColorIconPath
                                                  : AssetPaths
                                                      .iconPath.getBeatIconPath,
                                              width: 28,
                                              height: 28,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (model.currentTrack!
                                                          .karaokeLink !=
                                                      null &&
                                                  model
                                                      .currentTrack!
                                                      .karaokeLink!
                                                      .isNotEmpty) {
                                                model.pause();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            KaraokeScreen(
                                                              videoURL: model
                                                                  .currentTrack!
                                                                  .karaokeLink!,
                                                              imageURL: model
                                                                      .currentTrack
                                                                      ?.imageURL ??
                                                                  "",
                                                            )));
                                              } else {
                                                AppToaster.showToast(
                                                  context: context,
                                                  msg:
                                                      'This track does not have karaoke!',
                                                  type: AppToasterType.warning,
                                                );
                                              }
                                            },
                                            child: Image.asset(
                                              AssetPaths
                                                  .iconPath.getKaraokeIconPath,
                                              width: 28,
                                              height: 28,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _controller.nextPage(
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.easeOut);
                                            },
                                            child: Image.asset(
                                              AssetPaths
                                                  .iconPath.getLyricsIconPath,
                                              width: 28,
                                              height: 28,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            _track?.lyrics != null && _track!.lyrics!.isNotEmpty
                                ? SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 20),
                                            child: Text(
                                              "${_track?.lyrics}"
                                                  .replaceAll("\\n", "\n"),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            )),
                                      ],
                                    ),
                                  )
                                : const Center(
                                    child: Text(
                                    "Have no lyrics",
                                    style: TextStyle(color: Colors.white),
                                  )),
                          ],
                        ),
                      )
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ));
      },
    );
  }

  String shuffleImage(PlayViewModel model) {
    if (model.isShuffle) {
      return AssetPaths.iconPath.getShuffleColorIconPath;
    } else {
      return AssetPaths.iconPath.getShuffleIconPath;
    }
  }

  Widget loopImage(PlayViewModel model) {
    switch (model.repeatState) {
      case RepeatState.off:
        return Image.asset(
          AssetPaths.iconPath.getRepeatIconPath,
          width: 32,
        );
      case RepeatState.repeatPlaylist:
        return Image.asset(
          AssetPaths.iconPath.getRepeatColorIconPath,
          width: 32,
        );
      case RepeatState.repeatSong:
        return Stack(
          children: [
            Image.asset(
              AssetPaths.iconPath.getRepeatColorIconPath,
              width: 32,
            ),
            Positioned(
              top: 10,
              left: 13,
              child: Text(
                '1',
                style: TextStyle(
                  color: AppColors().purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        );
    }
  }
}
