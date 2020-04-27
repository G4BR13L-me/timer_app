import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:fast_noise/fast_noise.dart' as noise;

class SandFall extends CustomPainter {
  static List<double> path = [];
  Random r = Random();
  double num;
  SandFall(this.num);

  @override
  void paint(Canvas canvas, Size size) {
    if(num==0){ _initPoints(size.height); print('Initialize');}
    else {_switchPosition();print('Switch');}
    var paint = Paint();
    var index = 0; 

    for (var i = 5.0; i < size.height; i+=10) {
      canvas.drawCircle(Offset(size.width/2.0, i), path[index++] , paint);
    }
  }

  @override
  bool shouldRepaint(SandFall oldDelegate) => true;

  _switchPosition(){
    var aux = path.sublist(0);
    path[0] = aux[aux.length-1];
    for (var i = 0; i < path.length-1; i++) {
      path[i+1] = aux[i];  
    }
  }

  _initPoints(double size){
    for (var i = 5.0; i < size; i+=10) {
      path.add(r.nextDouble()*5);
    }
  }
}
