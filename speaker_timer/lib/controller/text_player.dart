import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speaker_timer/screen/stopwatch/stopwatch_screen.dart';

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
  int time = 0;
  String title;

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
    title = params['title'];
    playPause();
    while(true){
      AudioServiceBackground.setMediaItem(mediaItem(time));
      AudioServiceBackground.androidForceEnableMediaButtons();
      //if(title=='Timer')
        _tts.speak('${StopWatch.getDisplayTimeSecond(time)}');
      
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
  }

  MediaItem mediaItem(int number) => MediaItem(
      id: '$number',
      title: title,
      album: StopWatch.getDisplayTime(number),
      );

  void playPause() {
    if (_playing) {
      AudioServiceBackground.sendCustomEvent('pause$title');
      _tts.stop();
      AudioServiceBackground.setState(
        controls: [playControl, stopControl],
        processingState: AudioProcessingState.ready,
        playing: false,
      );
    } else {
      AudioServiceBackground.sendCustomEvent('playing$title');
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
  Future onStop() async {
    AudioServiceBackground.sendCustomEvent('stop$title');
    if (_processingState != AudioProcessingState.stopped) {
      _tts.stop();
      await AudioServiceBackground.setState(
        controls: [],
        processingState: AudioProcessingState.stopped,
        playing: false,
      );
      _playPauseCompleter.complete();
    }
    await super.onStop();
  }

  @override
  Future onCustomAction(String name, arguments) {
    if (name == 'setTime$title') {
      time = arguments;
    }

    return super.onCustomAction(name, arguments);
  }
}