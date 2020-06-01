import 'package:flutter_tts/flutter_tts.dart';
import 'package:audio_service/audio_service.dart';
import 'dart:async';

import 'package:stop_watch_timer/stop_watch_timer.dart';

MediaControl stopControl = MediaControl(
  androidIcon: 'drawable/ic_action_stop',
  label: 'Stop',
  action: MediaAction.stop,
);
MediaControl playControl = MediaControl(
  androidIcon: 'drawable/ic_action_play_arrow',
  label: 'Play',
  action: MediaAction.play,
);
MediaControl pauseControl = MediaControl(
  androidIcon: 'drawable/ic_action_pause',
  label: 'Pause',
  action: MediaAction.pause,
);

class TextPlayerTask extends BackgroundAudioTask {
  final int number;
  final String title;

  TextPlayerTask(this.title,{this.number=1000});

  FlutterTts _tts = FlutterTts();

  /// Represents the completion of a period of playing or pausing.
  Completer _playPauseCompleter = Completer();
    AudioProcessingState get _processingState =>
      AudioServiceBackground.state.processingState;

  bool get _playing => AudioServiceBackground.state.playing;

  /// This wraps [_playPauseCompleter.future], replacing [_playPauseCompleter]
  /// if it has already completed.
  Future _playPauseFuture() {
    if (_playPauseCompleter.isCompleted) _playPauseCompleter = Completer();
    return _playPauseCompleter.future;
  }

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    playPause();
    int second = params['stopWatch'].secondTime.value;
    AudioServiceBackground.setMediaItem(mediaItem(second));
    AudioServiceBackground.androidForceEnableMediaButtons();
    _tts.speak('$second');
    // Wait for the speech or a pause request.
    await Future.any(
        [Future.delayed(Duration(seconds: 1)), _playPauseFuture()]);
    // If we were just paused...
    if (_playPauseCompleter.isCompleted &&
        !_playing &&
        _processingState != AudioProcessingState.stopped) {
      // Wait to be unpaused...
      await _playPauseFuture();
    }
    
    if (_processingState != AudioProcessingState.stopped) onStop();
  }

  MediaItem mediaItem(int number) => MediaItem(
      id: 'tts_$number',
      title: '$title',
      album: '$number',
      );

  void playPause() {
    if (_playing) {
      _tts.stop();
      AudioServiceBackground.setState(
        controls: [playControl, stopControl],
        processingState: AudioProcessingState.ready,
        playing: false,
      );
    } else {
      AudioServiceBackground.setState(
        controls: [pauseControl, stopControl],
        processingState: AudioProcessingState.ready,
        playing: true,
      );
    }
    _playPauseCompleter.complete();
  }

  @override
  void onPlay() {
    playPause();
  }

  @override
  void onPause() {
    playPause();
  }

  @override
  void onClick(MediaButton button) {
    playPause();
  }

  @override
  void onStop() async {
    if (_processingState == AudioProcessingState.stopped) return;
    _tts.stop();
    await AudioServiceBackground.setState(
      controls: [],
      processingState: AudioProcessingState.stopped,
      playing: false,
    );
    _playPauseCompleter.complete();
  }
}
/*
class TextPlayerTask extends BackgroundAudioTask {
  FlutterTts _tts = FlutterTts();

  /// Represents the completion of a period of playing or pausing.
  Completer _playPauseCompleter = Completer();

  /// This wraps [_playPauseCompleter.future], replacing [_playPauseCompleter]
  /// if it has already completed.
  Future _playPauseFuture() {
    if (_playPauseCompleter.isCompleted) _playPauseCompleter = Completer();
    return _playPauseCompleter.future;
  }

  AudioProcessingState get _processingState =>
      AudioServiceBackground.state.processingState;

  bool get _playing => AudioServiceBackground.state.playing;

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    playPause();
    for (var i = 1;
        i <= 10 && _processingState != AudioProcessingState.stopped;
        i++) {
      AudioServiceBackground.setMediaItem(mediaItem(i));
      AudioServiceBackground.androidForceEnableMediaButtons();
      _tts.speak('$i');
      // Wait for the speech or a pause request.
      await Future.any(
          [Future.delayed(Duration(seconds: 1)), _playPauseFuture()]);
      // If we were just paused...
      if (_playPauseCompleter.isCompleted &&
          !_playing &&
          _processingState != AudioProcessingState.stopped) {
        // Wait to be unpaused...
        await _playPauseFuture();
      }
    }
    if (_processingState != AudioProcessingState.stopped) onStop();
  }

  MediaItem mediaItem(int number) => MediaItem(
      id: 'tts_$number',
      album: 'Numbers',
      title: 'Number $number',
      artist: 'Sample Artist');

  void playPause() {
    if (_playing) {
      _tts.stop();
      AudioServiceBackground.setState(
        controls: [playControl, stopControl],
        processingState: AudioProcessingState.ready,
        playing: false,
      );
    } else {
      AudioServiceBackground.setState(
        controls: [pauseControl, stopControl],
        processingState: AudioProcessingState.ready,
        playing: true,
      );
    }
    _playPauseCompleter.complete();
  }

  @override
  void onPlay() {
    playPause();
  }

  @override
  void onPause() {
    playPause();
  }

  @override
  void onClick(MediaButton button) {
    playPause();
  }

  @override
  Future<void> onStop() async {
    if (_processingState == AudioProcessingState.stopped) return;
    _tts.stop();
    await AudioServiceBackground.setState(
      controls: [],
      processingState: AudioProcessingState.stopped,
      playing: false,
    );
    _playPauseCompleter.complete();
  }
}
*/