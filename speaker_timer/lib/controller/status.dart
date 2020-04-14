import 'package:flutter/material.dart';

class PlayStatus with ChangeNotifier {
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;
  set isPlaying(bool value) {
    _isPlaying = value;
    notifyListeners();
  }
}