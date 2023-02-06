import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/repository/track_repository.dart';

import '../models/playlist.dart';
import '../models/track.dart';

enum ButtonState {
  paused,
  playing,
  loading,
}

enum RepeatState {
  off,
  repeatSong,
  repeatPlaylist,
}


class ProgressBarState {
  const ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });

  final Duration current;
  final Duration buffered;
  final Duration total;
}

class TrackViewModel extends ChangeNotifier {
  AudioPlayer? _audioPlayer;
  ButtonState? playButton;
  ProgressBarState? progressBar;
  ConcatenatingAudioSource? _playlist;
  RepeatState repeatState = RepeatState.off;
  bool isShuffle = false;

  void init(String mp3Link) async {
    disposed();
    _audioPlayer = AudioPlayer();
    progressBar = const ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    );
    await _audioPlayer?.setUrl(mp3Link);
    play();
    notifyListeners();
    _listenForChangesInPlayerState();
    _listenForChangesInPlayerPosition();
    _listenForChangesInBufferedPosition();
    _listenForChangesInTotalDuration();
  }

  void initPlaylist(List<Track> tracks) async {
    disposed();
    // List<Track> tracks = [];
    // List<AudioSource> sources = [];
    // playlist.listTrackId.forEach((element) async {
    //   var track = await TrackRepository().getTrackById(element);
    //   print(element);
    //   print(track.mp3Link);
    //   tracks.add(track);
    //   sources.add(AudioSource.uri(
    //     Uri.parse(
    //       track.mp3Link,
    //     ),
    //   ));
    // });

    _audioPlayer = AudioPlayer();
    progressBar = const ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    );
    List<AudioSource> sources = [];
    tracks.forEach((element) {
      print(tracks.length);
      print(element.mp3Link);
      var source = AudioSource.uri(Uri.parse(element.mp3Link));
      sources.add(source);
    });
    _playlist = ConcatenatingAudioSource(
      children: sources,
    );
    await _audioPlayer?.setAudioSource(_playlist!);
    play();
    notifyListeners();
    _listenForChangesInPlayerState();
    _listenForChangesInPlayerPosition();
    _listenForChangesInBufferedPosition();
    _listenForChangesInTotalDuration();
  }

  void _listenForChangesInPlayerState() {
    _audioPlayer?.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        playButton = ButtonState.loading;
      } else if (!isPlaying) {
        playButton = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        playButton = ButtonState.playing;
      } else {
        _audioPlayer?.seek(Duration.zero);
        _audioPlayer?.pause();
      }
      notifyListeners();
    });
  }

  void _listenForChangesInPlayerPosition() {
    _audioPlayer?.positionStream.listen((position) {
      final oldState = progressBar;
      progressBar = ProgressBarState(
        current: position,
        buffered: oldState!.buffered,
        total: oldState.total,
      );
      notifyListeners();
    });
  }

  void _listenForChangesInBufferedPosition() {
    _audioPlayer?.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressBar;
      progressBar = ProgressBarState(
        current: oldState!.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
      notifyListeners();
    });
  }

  void _listenForChangesInTotalDuration() {
    _audioPlayer?.durationStream.listen((totalDuration) {
      final oldState = progressBar;
      progressBar = ProgressBarState(
        current: oldState!.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
      notifyListeners();
    });
  }

  void play() async {
    _audioPlayer?.play();
  }

  void pause() {
    _audioPlayer?.pause();
  }

  void seek(Duration position) {
    _audioPlayer?.seek(position);
  }

  void disposed() {
    _audioPlayer?.dispose();
    playButton = null;
    progressBar = null;
  }

  void onPreviousSongButtonPressed() {
    _audioPlayer?.seekToPrevious();
  }

  void onNextSongButtonPressed() {
    _audioPlayer?.seekToNext();
  }

  void onShuffleButtonPressed() async {
    if (_audioPlayer != null) {
      final enable = !_audioPlayer!.shuffleModeEnabled;
      if (enable) {
        await _audioPlayer!.shuffle();
      }
      await _audioPlayer!.setShuffleModeEnabled(enable);
      isShuffle = enable;
      notifyListeners();
    }
  }

  void onRepeatButtonPressed() {
    if (_audioPlayer != null) {
      var next = (repeatState.index + 1) % RepeatState.values.length;
      repeatState = RepeatState.values[next];
      switch (repeatState) {
        case RepeatState.off:
          _audioPlayer!.setLoopMode(LoopMode.off);
          break;
        case RepeatState.repeatSong:
          _audioPlayer!.setLoopMode(LoopMode.one);
          break;
        case RepeatState.repeatPlaylist:
          _audioPlayer!.setLoopMode(LoopMode.all);
      }
      notifyListeners();
    }
  }

}
