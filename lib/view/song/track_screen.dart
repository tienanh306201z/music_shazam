import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/track.dart';
import 'package:music_app/repository/track_repository.dart';
import 'package:music_app/utils/extension.dart';
import 'package:provider/provider.dart';

import '../../view_model/track_view_model.dart';

class TrackScreen extends StatefulWidget {
  final Track track;

  const TrackScreen({Key? key, required this.track}) : super(key: key);

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
    Provider.of<TrackViewModel>(context, listen: false)
        .init(widget.track.mp3Link);
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
              image: NetworkImage(widget.track.imageURL),
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
                    widget.track.imageURL,
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
                            widget.track.name,
                            style: TextStyle(
                              fontSize: 24,
                              color: "#FFFFFF".toColor(),
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        FutureBuilder(
                          future: TrackRepository().getArtistById(widget.track.artistId),
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
                        ),
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
                                onTap: () {},
                                child: Image.asset(
                                  "assets/icon/u_arrow-random.png",
                                  width: 24,
                                ),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {},
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
                                    onTap: () {},
                                    child: Image.asset(
                                      "assets/icon/next.png",
                                      width: 24,
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {},
                                child: Image.asset(
                                  "assets/icon/fi_refresh-cw.png",
                                  width: 24,
                                ),
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
}
