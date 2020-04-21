import 'package:flutter/material.dart';

class PlayStatus with ChangeNotifier {
  bool _isPlaying = false;
  bool _reset = false;

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
}