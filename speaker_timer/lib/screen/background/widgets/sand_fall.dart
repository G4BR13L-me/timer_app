import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:speaker_timer/controller/status.dart';

class SandFall extends CustomPainter {
  static List<double> path = [];
  final Random r = Random();
  final PlayStatus playStatus;
  final BuildContext context;
  SandFall(this.playStatus,this.context);

  @override
  void paint(Canvas canvas, Size size) {
    if(playStatus.reset) {path=[]; _initPoints(size.height);}
    else if(playStatus.isPlaying) {_switchPosition();_increaseSandDrop();}
    else {_switchPosition(); _cleanDrop();}

    var paint = Paint()
    ..color = Theme.of(context).primaryColor;
    var index = 0; 

    for (var i = 5.0; i < size.height; i+=10) {
      canvas.drawCircle(Offset(size.width/2.0, i), path[index++] , paint);
    }
  }

  @override
  bool shouldRepaint(SandFall oldDelegate) => true;

  _cleanDrop(){
    path[0] = 0;
  }

  _increaseSandDrop(){
    path[0] = r.nextDouble()*5;
  }

  _switchPosition(){
    var aux = path.sublist(0);
    path[0] = aux[aux.length-1];
    for (var i = 0; i < path.length-1; i++) {
      path[i+1] = aux[i];  
    }
  }

  _initPoints(double size){
    for (var i = 5.0; i < size; i+=10) {
      path.add(0);
    }
  }
}
