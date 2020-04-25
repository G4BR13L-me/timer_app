import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui';

class SandFall extends CustomPainter {

  List<Offset> path = List<Offset>();
  Random r = Random();

  @override
  void paint(Canvas canvas, Size size) {
    if(path.isEmpty) _initPoints();
    var paint = Paint();

    for (var i = 5.0; i < size.height; i+=10) {
      canvas.drawCircle(Offset(size.width/2.0, i), r.nextDouble()*5 , paint);
    }



  }

  @override
  bool shouldRepaint(SandFall oldDelegate) => true;

  void _initPoints() {

  }
}
