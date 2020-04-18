import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

class Sand extends CustomPainter{
  final double height;
  final bool bottom;

  Sand(this.height,this.bottom);


  @override
  void paint(Canvas canvas, Size size) {

    Size s = Size(bottom? size.width:-size.width,bottom?size.height:-size.height);
    var path = Path();
    var paint = Paint();
    
    if(height>=-0.75){
      path.moveTo(0,s.height);
      path.quadraticBezierTo(s.width*0.50, s.height*height, s.width, s.height);
      path.lineTo(s.width, s.height);
      path.lineTo(0, s.height);
      path.close();
      paint.color = Colors.yellow;
      paint.maskFilter = MaskFilter.blur(BlurStyle.inner, 2.0);
      canvas.drawPath(path, paint);

    }
    else{
      path.moveTo(0,s.height);
      path.lineTo(s.width, s.height);
      path.lineTo(s.width/2.0, s.height*height*0.5);
      path.lineTo(0, s.height);
      path.close();
      paint.color = Colors.amber;
      paint.maskFilter = MaskFilter.blur(BlurStyle.inner, 5.0);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(Sand oldDelegate) => this.height != oldDelegate.height;
}
