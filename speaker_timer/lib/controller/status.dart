import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class PlayStatus with ChangeNotifier {
  final BehaviorSubject<bool> _isPlayingController = BehaviorSubject<bool>.seeded(false);
  ValueStream<bool> get isPlayingStream => _isPlayingController;
  bool _isPlaying = false;
  bool _reset = true;

  bool get isPlaying => _isPlaying;
  set isPlaying(bool value) {
    _isPlayingController.add(value);
    _isPlaying = value;
    notifyListeners();
  }

  bool get reset => _reset;
  set reset(bool value) {
    _reset = value;
    notifyListeners();
  }
}