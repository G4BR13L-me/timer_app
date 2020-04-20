import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

class Sand extends CustomPainter {
  final double height;
  final bool bottom;

  Sand(this.height, this.bottom);

  @override
  void paint(Canvas canvas, Size size) {
    Size s = Size(
        bottom ? size.width : -size.width, bottom ? size.height : -size.height);
    var path = Path();
    var paint = Paint();
    var r = Random();
    paint.color = Colors.yellow;
    
    paint.strokeWidth = 1.5;
    //paint.maskFilter = MaskFilter.blur(BlurStyle.solid,0.8);

    if (height >= -0.75) {
      path.moveTo(0, s.height);
      path.quadraticBezierTo(
          s.width * 0.50, s.height * height, s.width, s.height);
      path.lineTo(s.width, s.height);
      path.lineTo(0, s.height);
      path.close();
      canvas.drawPath(path, paint);
      canvas.clipPath(path);
      paint.color = Colors.amber;
      List<Offset> points = List<Offset>();
      for (var i = 0; i < size.width; i+=2) {
        for (var j = 0; j < size.height; j+=2) {
          points.add(Offset(r.nextDouble()*s.width, r.nextDouble()*s.height));
        }
      }
      canvas.drawPoints(PointMode.points, points, paint);
    } else {
      path.moveTo(0, s.height);
      path.lineTo(s.width, s.height);
      path.lineTo(s.width / 2.0, s.height * height * 0.5);
      path.lineTo(0, s.height);
      path.close();
      canvas.drawPath(path, paint);
      canvas.clipPath(path);

      paint.color = Colors.amber;
      List<Offset> points = List<Offset>();
      for (var i = 0; i < size.width; i+=2) {
        for (var j = 0; j < size.height; j+=2) {
          points.add(Offset(r.nextDouble()*s.width, r.nextDouble()*s.height));
        }
      }
      canvas.drawPoints(PointMode.points, points, paint);
    }
  }

  @override
  bool shouldRepaint(Sand oldDelegate) => this.height != oldDelegate.height;
}
