import 'package:flutter/material.dart';
import 'package:speaker_timer/controller/status.dart';
import 'dart:math' as math;

import 'package:speaker_timer/screen/stopwatch/stopwatch_screen.dart';

class Crystal extends StatelessWidget {
  Crystal(this.width, this.height,this.player);
  final double width;
  final double height;
  final PlayStatus player;

  @override
  Widget build(BuildContext context) {
    if(width>height)
    return Transform(
      origin: Offset(width/8.0,width/8.0),
        child: Container(
          width: width / 4 ,
          height: width / 4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color(0xFFDF9595),),
          child: Transform.rotate(
            angle: -0.8,
            child: StopWatch(player)
          ),
        ), 
        transform: Matrix4.translationValues(width/10.0, -height/70, 0)..rotateZ(math.pi/4.0),
        );
      else
      return Transform(
      origin: Offset( height/7.0,height/7.0),
        child: Container(
          width: height / 3.5,
          height: height / 3.5,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color(0xFFDF9595),
              boxShadow: [BoxShadow(
                blurRadius: 2.0,
              )]),
          child: Transform.rotate(
            angle: -0.8,
            child: StopWatch(player)
          ),
        ), 
        transform: Matrix4.translationValues(width/10.0, 0, 0)..rotateZ(math.pi/4.0),
        );
  }
}