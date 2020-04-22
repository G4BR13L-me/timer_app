import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui';

class Sand extends CustomClipper<Path> {
  final double height;
  final double width;
  final bool bottom;

  Sand(this.height, this.bottom,{this.width});

  @override
  getClip(Size size) {
    var path = Path();


    if(bottom){
      if (height >= -0.8) {
        path.moveTo(0, size.height);
        path.quadraticBezierTo(
            size.width * 0.50, size.height * height, size.width, size.height);
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        path.close();
      } else {
        path.moveTo(0, size.height);
        path.lineTo(size.width, size.height);
        path.lineTo(size.width / 2.0, size.height * height * 0.5);
        path.close();
      }
    }else{
      path.moveTo(width, size.height);
      path.lineTo(size.width-width, size.height);
      path.lineTo(size.width / 2.0, size.height *height);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;

  /*
  @override
  void paint(Canvas canvas, Size s) {
    var path = Path();
    var paint = Paint();
    paint.color = Colors.yellow;

    if(bottom){
      if (height >= -0.85) {
        path.moveTo(0, s.height);
        path.quadraticBezierTo(
            s.width * 0.50, s.height * height, s.width, s.height);
        path.lineTo(s.width, s.height);
        path.lineTo(0, s.height);
        path.close();
        canvas.drawPath(path, paint);
      } else {
        path.moveTo(0, s.height);
        path.lineTo(s.width, s.height);
        path.lineTo(s.width / 2.0, s.height * height * 0.5);
        path.close();
        canvas.drawPath(path, paint);
      }
    }else{
      Size s = Size(-s.width,-s.height);
      path.moveTo(0, s.height);
      path.lineTo(s.width, s.height);
      path.lineTo(s.width / 2.0, s.height *-0.4);

      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(Sand oldDelegate) => false;*/
}
