import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui';

class SandFall extends CustomPainter {
  final bool bottom;

  SandFall(this.bottom);

  @override
  void paint(Canvas canvas, Size size) {
    final Size s = Size(
        bottom ? size.width : -size.width, bottom ? size.height : -size.height);
    var r = Random();
    var path = Path();
    var paint = Paint()
    ..color = Colors.amber
    ..strokeWidth = 1.5;

    path.lineTo(s.width, 0);
    path.lineTo(0, s.height);
    path.moveTo(s.width, 0);
    path.lineTo(s.width, s.height);
    path.close();

    canvas.clipPath(path);

    for (var i = 0; i < size.width; i+=2) {
      for (var j = 0; j < size.height; j+=2) {
        var point = Offset(r.nextDouble()*s.width,r.nextDouble()*s.height);
        canvas.drawPoints(PointMode.points, [point], paint);
      }
    }
  }

  @override
  bool shouldRepaint(SandFall oldDelegate) => true;
}
