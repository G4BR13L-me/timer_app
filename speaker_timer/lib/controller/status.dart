import 'package:flutter/material.dart';

class PlayStatus with ChangeNotifier {
  bool _completeCount = false;
  bool _isRestRunning = false;
  bool _isTimerSelected = false;
  bool _isPlaying = false;
  bool _reset = true;

  bool get isPlaying => _isPlaying;
  set isPlaying(bool value) {
    _isPlaying = value;
    notifyListeners();
  }

  bool get reset => _reset;
  set reset(bool value) {
    _reset = value;
    notifyListeners();
  }

  bool get isTimerSelected => _isTimerSelected;
  set isTimerSelected(bool value) {
    _isTimerSelected = value;
    notifyListeners();
  }

  bool get isCompleteCount => _completeCount;
  set isCompleteCount(bool value) {
    _completeCount = value;
    notifyListeners();
  }

  bool get isRestRunning => _isRestRunning;
  set isRestRunning(bool value) {
    _isRestRunning = value;
    notifyListeners();
  }
}