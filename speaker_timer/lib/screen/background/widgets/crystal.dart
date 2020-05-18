import 'package:flutter/material.dart';
import 'dart:math' as math;

class Crystal extends StatelessWidget {
  Crystal({@required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if(size.width>size.height)
    return Transform(
      origin: Offset(size.width/8.0,size.width/8.0),
        child: Container(
          width: size.width / 4 ,
          height: size.width / 4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color(0xFFDF9595),),
          child: Transform.rotate(
            angle: -0.8,
            child: child
          ),
        ), 
        transform: Matrix4.translationValues(size.width/10.0, -size.height/70, 0)..rotateZ(math.pi/4.0),
        );
      else
      return Transform(
      origin: Offset( size.height/7.0,size.height/7.0),
        child: Container(
          width: size.height / 3.5,
          height: size.height / 3.5,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color(0xFFDF9595),
              boxShadow: [BoxShadow(
                blurRadius: 2.0,
              )]),
          child: Transform.rotate(
            angle: -0.8,
            child: child
          ),
        ), 
        transform: Matrix4.translationValues(size.width/10.0, 0, 0)..rotateZ(math.pi/4.0),
        );
  }
}