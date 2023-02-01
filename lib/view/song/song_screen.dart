import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/utils/extension.dart';
import 'package:music_app/view_model/song_view_model.dart';
import 'package:provider/provider.dart';

class SongScreen extends StatefulWidget {
  final Song song;
  const SongScreen({Key? key, required this.song}) : super(key: key);

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
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
    Provider.of<SongViewModel>(context, listen: false).initPlatformState(widget.song.songUrl);
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
                  image: NetworkImage(widget.song.imageUrl),
                  fit: BoxFit.cover,
                )),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
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
                    widget.song.imageUrl,
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
                            widget.song.name,
                            style: TextStyle(
                              fontSize: 24,
                              color: "#FFFFFF".toColor(),
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          widget.song.artistName,
                          style: TextStyle(
                              fontSize: 14, color: "99FFFFFF".toColor()),
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
                Consumer<SongViewModel>(
                  builder: (context, model, child) {
                    return Column(
                      children: [
                        StreamBuilder(
                          stream: model.assetsAudioPlayer?.currentPosition,
                          builder: (context, snapshot) {
                            final position = snapshot.data;
                            if (position?.inSeconds == model.mDuration?.inSeconds) {
                              model.changePlaying();
                            }
                            int minutes = (position?.inSeconds ?? 0) ~/ 60;
                            int seconds = (position?.inSeconds ?? 0) - minutes*60;
                            var strMin = minutes < 10 ? "0$minutes" : "$minutes";
                            var strSec = seconds < 10 ? "0$seconds" : "$seconds";
                            return Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width - 32,
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Colors.white,
                                      inactiveTrackColor: "#99FFFFFF".toColor(),
                                      trackShape: RectangularSliderTrackShape(),
                                      trackHeight: 3.0,
                                      thumbColor: Colors.white,
                                      thumbShape:
                                      RoundSliderThumbShape(enabledThumbRadius: 6.0),
                                      overlayColor: Colors.red.withAlpha(32),
                                      overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
                                    ),
                                    child: Slider(
                                      min: 0,
                                      max: model.mDuration?.inMicroseconds.toDouble() ?? 0,
                                      value: position?.inMicroseconds.toDouble() ?? 0,
                                      onChanged: (value) {
                                        model.assetsAudioPlayer?.seek(Duration(microseconds: value.toInt()));
                                        // setState(() {
                                        //   mValue = value;
                                        // });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '$strMin:$strSec',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        '${model.mStrMin}:${model.mStrSec}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                SizedBox(
                                  width: 32,
                                ),
                                InkWell(
                                  onTap: () {
                                    model.assetsAudioPlayer?.playOrPause();
                                    model.changePlaying();
                                  },
                                  child: Image.asset(
                                    (model.isPlaying)
                                        ? "assets/icon/pause.png"
                                        : "assets/icon/play-button-arrowhead.png",
                                    width: 36,
                                  ),
                                ),
                                SizedBox(
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
                        )
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
