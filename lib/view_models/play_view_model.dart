import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/repositories/global_repo.dart';

import '../models/db_models/track.dart';

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

class PlayViewModel extends ChangeNotifier {
  final globalRepo = GlobalRepo.getInstance;

  Track? currentTrack;
  List<Track>? playlist;
  int currentIndex = 0;

  AudioPlayer? _audioPlayer;
  ButtonState? playButton;
  ProgressBarState? progressBar;
  ConcatenatingAudioSource? _playlist;
  RepeatState repeatState = RepeatState.off;
  bool isShuffle = false;
  bool isPlayBeat = false;


  void changePlayBeat() {
    isPlayBeat = !isPlayBeat;
    notifyListeners();
  }

  void init(Track track, {bool isBeatLink = false}) async {
    disposed();
    currentTrack = track;
    _audioPlayer = AudioPlayer();
    progressBar = const ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    );
    if (isBeatLink && track.beatLink != null) {
      isPlayBeat = true;
      await _audioPlayer?.setUrl(track.beatLink!);
    } else {
      isPlayBeat = false;
      await _audioPlayer?.setUrl(track.musicLink);
    }
    play();
    notifyListeners();
    _listenForChangesInPlayerState();
    _listenForChangesInPlayerPosition();
    _listenForChangesInBufferedPosition();
    _listenForChangesInTotalDuration();
    print("CHECK");
    if (!isBeatLink) {
      print("UPDATE");
      await globalRepo.updateListenCountTrack(track.id);
    }
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

    playlist = tracks;
    currentTrack = playlist![currentIndex];

    _audioPlayer = AudioPlayer();
    progressBar = const ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    );
    List<AudioSource> sources = [];
    for (var element in tracks) {
      var source = AudioSource.uri(Uri.parse(element.musicLink));
      sources.add(source);
    }
    _playlist = ConcatenatingAudioSource(
      children: sources,
    );
    await _audioPlayer?.setAudioSource(_playlist!);
    await globalRepo.updateListenCountTrack(currentTrack!.id);
    _audioPlayer?.currentIndexStream.listen((event) async {
      if (event != currentIndex) {
        currentIndex = event!;
        currentTrack = playlist![currentIndex];
        await globalRepo.updateListenCountTrack(currentTrack!.id);
        notifyListeners();
      }
    });

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

  Future<void> play() async {
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
    currentTrack = null;
    currentIndex = 0;
    playlist = null;
    // isPlayBeat = false;
  }

  void onPreviousSongButtonPressed() {
    _audioPlayer?.seekToPrevious();
  }

  void onNextSongButtonPressed() {
    _audioPlayer?.seekToNext();
  }

  Future<void> onShuffleButtonPressed() async {
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
