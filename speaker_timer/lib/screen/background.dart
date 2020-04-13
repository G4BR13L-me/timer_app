import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speaker_timer/controller/sand.dart';
import 'package:speaker_timer/controller/status.dart';
import 'package:speaker_timer/controller/wave.dart';

class Background extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final playStatus = Provider.of<PlayStatus>(context);
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        color: Colors.white,
        width: size.width,
        height: size.height,
        child:  AnimatedOpacity(
            opacity: playStatus.isPlaying ? 1.0 : 0.0,
            duration: Duration(seconds: 1),
            child: Wave(size: Size(size.width, 50))),
        //Sand.builder(context)
      ),
    );
  }
}