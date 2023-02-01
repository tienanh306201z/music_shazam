import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class SongViewModel extends ChangeNotifier {
  AssetsAudioPlayer? assetsAudioPlayer;
  bool isPlaying = false;

  Duration? mDuration;
  int mMinutes = 0;
  int mSeconds = 0;
  String mStrMin = "00";
  String mStrSec = "00";

  Future<void> initPlatformState(String songUrl) async {
    try {
      disposed();
      assetsAudioPlayer = AssetsAudioPlayer();
      await assetsAudioPlayer?.open(
          Audio.network(songUrl)
      );
      isPlaying = true;
      mDuration = assetsAudioPlayer?.current.value?.audio.duration;
      mMinutes = (mDuration?.inSeconds ?? 0) ~/ 60;
      mSeconds = (mDuration?.inSeconds ?? 0) - mMinutes*60;
      mStrMin = mMinutes < 10 ? "0$mMinutes" : "$mMinutes";
      mStrSec = mSeconds < 10 ? "0$mSeconds" : "$mSeconds";
      // assetsAudioPlayer?.isPlaying.listen((event) {
      //   if (!event) {
      //     isPlaying = false;
      //     notifyListeners();
      //   }
      // });
      notifyListeners();
    } catch (t) {
      //mp3 unreachable
    }
  }

  changePlaying() {
    isPlaying = !isPlaying;
    notifyListeners();
  }

  void disposed() {
    assetsAudioPlayer?.dispose();
    isPlaying = false;
    mDuration = null;
    mMinutes = 0;
    mSeconds = 0;
    mStrMin = "00";
    mStrSec = "00";
    notifyListeners();
  }
}