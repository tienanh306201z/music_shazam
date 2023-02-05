import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

enum ButtonState { paused, playing, loading, }

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
}