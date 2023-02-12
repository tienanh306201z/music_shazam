import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_app/models/db_models/playlist.dart';
import 'package:music_app/repositories/global_repo.dart';
import 'package:music_app/utils/constants.dart';
import 'package:music_app/utils/constants/asset_paths.dart';
import 'package:music_app/utils/extension.dart';
import 'package:music_app/view_models/play_view_model.dart';
import 'package:provider/provider.dart';

import '../../../models/db_models/app_user.dart';
import '../../../models/db_models/track.dart';
import '../../../utils/app_flushbar.dart';
import '../../../view_models/user_view_model.dart';
import 'karaoke_screen.dart';

final globalRepo = GlobalRepo.getInstance;

class PlayScreen extends StatefulWidget {
  Track? track;
  AppPlaylist? playlist;
  bool isPlaylist;
  List<Track>? tracks;
  bool isInit;

  PlayScreen({
    Key? key,
    this.track,
    this.playlist,
    this.tracks,
    this.isInit = true,
    this.isPlaylist = false,
  }) : super(key: key);

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  late AppUser? user;

  late PageController controller;

  @override
  void initState() {
    super.initState();
    if (widget.isInit) {
      if (!widget.isPlaylist) {
        Provider.of<PlayViewModel>(context, listen: false).init(
          widget.track!,
        );
      } else {
        Provider.of<PlayViewModel>(context, listen: false)
            .initPlaylist(widget.tracks!);
        globalRepo.updateListenCountPlaylist(widget.playlist!.id);
      }
    }
    user = Provider.of<UserViewModel>(context, listen: false).currentUser;
    controller = PageController();
  }

  // Initializing the Music Player and adding a single [PlaylistItem]
  // Future<void> initPlatformState() async {
  //   try {
  //     await assetsAudioPlayer.open(
  //       Audio.network(widget.song.songUrl)
  //     );
  //     mDuration = assetsAudioPlayer.current.value?.audio.duration;
  //     mMinutes = (mDuration?.inSeconds ?? 0) ~/ 60;
  //     mSeconds = (mDuration?.inSeconds ?? 0) - mMinutes*60;
  //     mStrMin = mMinutes < 10 ? "0$mMinutes" : "$mMinutes";
  //     mStrSec = mSeconds < 10 ? "0$mSeconds" : "$mSeconds";
  //     assetsAudioPlayer.isPlaying.listen((event) {
  //       if (!event) {
  //         setState(() {
  //           isPlaying = false;
  //         });
  //       }
  //     });
  //   } catch (t) {
  //     //mp3 unreachable
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayViewModel>(
      builder: (context, model, child) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                constraints: const BoxConstraints.expand(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(
                      model.currentTrack?.imageURL ?? Constants().loadingImage),
                  fit: BoxFit.cover,
                )),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: "#AA110929".toColor(),
                  ),
                ),
              ),
              PageView(
                controller: controller,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: Image.network(
                            model.currentTrack?.imageURL ??
                                Constants().loadingImage,
                            width: 250.0,
                            height: 250.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 300,
                                  child: Text(
                                    model.currentTrack!.name,
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: "#FFFFFF".toColor(),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                model.currentTrack!.artistId != null &&
                                        model.currentTrack!.artistId.isNotEmpty
                                    ? FutureBuilder(
                                        future: globalRepo.getArtistById(
                                            model.currentTrack!.artistId),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              snapshot.data!.name,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: "99FFFFFF".toColor()),
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            StreamBuilder<DocumentSnapshot>(
                              stream: globalRepo
                                  .getStreamTrackById(model.currentTrack!.id),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var track = Track.fromMap(snapshot.data
                                      ?.data() as Map<String, dynamic>);
                                  return InkWell(
                                    onTap: () {
                                      if (user != null) {
                                        globalRepo.updateFavoriteUserList(
                                            user!.id, track.id);
                                      }
                                    },
                                    child: Image.asset(
                                      user != null
                                          ? track.favoriteUserIdList
                                                  .contains(user!.id)
                                              ? AssetPaths
                                                  .iconPath.getHeartFillIconPath
                                              : AssetPaths
                                                  .iconPath.getHeartIconPath
                                          : AssetPaths
                                              .iconPath.getHeartIconPath,
                                      width: 24,
                                    ),
                                  );
                                } else {
                                  return Image.asset(
                                    AssetPaths.iconPath.getHeartIconPath,
                                    width: 24,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Column(
                          children: [
                            ProgressBar(
                              baseBarColor: "#77FFFFFF".toColor(),
                              bufferedBarColor: "#99FFFFFF".toColor(),
                              progressBarColor: Colors.white,
                              thumbColor: Colors.white,
                              thumbRadius: 8,
                              timeLabelTextStyle:
                                  const TextStyle(color: Colors.white),
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
                                          model.onPreviousSongButtonPressed();
                                        },
                                        child: Image.asset(
                                          AssetPaths
                                              .iconPath.getPreviousIconPath,
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
                                            AssetPaths.iconPath.getPlayIconPath,
                                            width: 36,
                                          ),
                                        ),
                                      if (model.playButton ==
                                          ButtonState.playing)
                                        InkWell(
                                          onTap: model.pause,
                                          child: Image.asset(
                                            AssetPaths
                                                .iconPath.getPauseIconPath,
                                            width: 36,
                                          ),
                                        ),
                                      const SizedBox(
                                        width: 32,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          model.onNextSongButtonPressed();
                                        },
                                        child: Image.asset(
                                          AssetPaths.iconPath.getNextIconPath,
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
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (model.currentTrack!.beatLink != null &&
                                        model.currentTrack!.beatLink!
                                            .isNotEmpty) {
                                      if (model.isPlayBeat) {
                                        model.init(
                                          model.currentTrack!,
                                        );
                                      } else {
                                        model.init(model.currentTrack!,
                                            isBeatLink: true);
                                      }
                                      // model.changePlayBeat();
                                    } else {
                                      AppSnackBar.showSnackBar(
                                          context,
                                          'This track does not have beat!',
                                          AppSnackBarType.warning);
                                    }
                                  },
                                  child: Image.asset(
                                    model.isPlayBeat
                                        ? AssetPaths
                                            .iconPath.getBeatColorIconPath
                                        : AssetPaths.iconPath.getBeatIconPath,
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (model.currentTrack!.karaokeLink !=
                                        null) {
                                      model.pause();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => KaraokeScreen(
                                                    videoURL: model
                                                        .currentTrack!
                                                        .karaokeLink!,
                                                  )));
                                    }
                                  },
                                  child: Image.asset(
                                    AssetPaths.iconPath.getKaraokeIconPath,
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    controller.nextPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeOut);
                                  },
                                  child: Image.asset(
                                    AssetPaths.iconPath.getLyricsIconPath,
                                    width: 20,
                                    height: 20,
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
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 16,
                            ),
                            InkWell(
                              onTap: () {
                                controller.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut);
                              },
                              child: const Icon(
                                Icons.arrow_back_outlined,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              'Lyrics',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          child: widget.track?.lyrics != null &&
                                  widget.track!.lyrics.isNotEmpty
                              ? Text(
                                  "${widget.track?.lyrics}",
                                  style: const TextStyle(color: Colors.white),
                                )
                              : const Text(
                                  "Have no lyrics",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        );
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
