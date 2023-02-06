import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/playlist.dart';
import 'package:music_app/models/track.dart';
import 'package:music_app/repository/track_repository.dart';
import 'package:music_app/utils/constants.dart';
import 'package:music_app/utils/extension.dart';
import 'package:provider/provider.dart';

import '../../view_model/track_view_model.dart';

class TrackScreen extends StatefulWidget {
  Track? track;
  ThePlaylist? playlist;
  bool isPlaylist;
  List<Track>? tracks;

  TrackScreen({Key? key, this.track, this.playlist, this.tracks, this.isPlaylist = false}) : super(key: key);

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  // final assetsAudioPlayer = AssetsAudioPlayer();
  //
  // bool isPlaying = true;
  //
  // Duration? mDuration;
  // int mMinutes = 0;
  // int mSeconds = 0;
  // String mStrMin = "00";
  // String mStrSec = "00";

  @override
  void initState() {
    super.initState();
    if (!widget.isPlaylist) {
      Provider.of<TrackViewModel>(context, listen: false)
          .init(widget.track!.mp3Link);
    } else {
      Provider.of<TrackViewModel>(context, listen: false)
          .initPlaylist(widget.tracks!);
    }
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
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(widget.track?.imageURL ?? widget.playlist!.imageURL!),
              fit: BoxFit.cover,
            )),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: "#AA110929".toColor(),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Image.network(
                    widget.track?.imageURL ?? widget.playlist!.imageURL!,
                    width: 250.0,
                    height: 250.0,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
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
                            widget.track?.name ?? widget.playlist!.name,
                            style: TextStyle(
                              fontSize: 24,
                              color: "#FFFFFF".toColor(),
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        widget.track != null ? FutureBuilder(
                          future: TrackRepository().getArtistById(widget.track!.artistId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data!.name,
                                style: TextStyle(
                                    fontSize: 14, color: "99FFFFFF".toColor()),
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        ) : SizedBox(),
                      ],
                    ),
                    Image.asset(
                      "assets/icon/heart_fill.png",
                      width: 24,
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Consumer<TrackViewModel>(
                  builder: (context, model, child) {
                    return Column(
                      children: [
                        ProgressBar(
                          baseBarColor: "#77FFFFFF".toColor(),
                          bufferedBarColor: "#99FFFFFF".toColor(),
                          progressBarColor: Colors.white,
                          thumbColor: Colors.white,
                          thumbRadius: 8,
                          timeLabelTextStyle: TextStyle(color: Colors.white),
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
                                      "assets/icon/previous.png",
                                      width: 24,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 32,
                                  ),
                                  if (model.playButton == ButtonState.paused || model.playButton == ButtonState.loading || model.playButton == null)
                                    InkWell(
                                      onTap: model.play,
                                      child: Image.asset('assets/icon/play-button-arrowhead.png', width: 36,),
                                    ),
                                  if (model.playButton == ButtonState.playing)
                                    InkWell(
                                      onTap: model.pause,
                                      child: Image.asset('assets/icon/pause.png', width: 36,),
                                    ),
                                  const SizedBox(
                                    width: 32,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      model.onNextSongButtonPressed();
                                    },
                                    child: Image.asset(
                                      "assets/icon/next.png",
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
                      ],
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  String shuffleImage(TrackViewModel model) {
    if (model.isShuffle) {
      return "assets/icon/shuffle_color.png";
    } else {
      return "assets/icon/shuffle.png";
    }
  }

  Widget loopImage(TrackViewModel model) {
    switch (model.repeatState) {
      case RepeatState.off:
        return Image.asset(
          "assets/icon/repeat.png",
          width: 32,
        );
      case RepeatState.repeatPlaylist:
        return Image.asset(
          "assets/icon/repeat_color.png",
          width: 32,
        );
      case RepeatState.repeatSong:
        return Stack(
          children: [
            Image.asset(
              "assets/icon/repeat_color.png",
              width: 32,
            ),
            Positioned(
              top: 10,
              left: 13,
              child: Text('1', style: TextStyle(color: AppColors().purple, fontWeight: FontWeight.bold, fontSize: 10),),
            ),
          ],
        );
    }
  }
}
