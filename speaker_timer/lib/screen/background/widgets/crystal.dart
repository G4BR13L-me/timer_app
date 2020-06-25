import 'package:flutter/material.dart';
import 'dart:math' as math;

class Crystal extends StatelessWidget {
  Crystal({@required this.child,@required this.color});
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
/*
    if(size.width>size.height)
    return Transform(
      origin: Offset(size.width/8.0,size.width/8.0),
        child: Container(
          width: size.width / 4 ,
          height: size.width / 4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: color,),
          child: Transform.rotate(
            angle: -0.8,
            child: child
          ),
        ), 
        transform: Matrix4.translationValues(size.width/10.0, -size.height/70, 0)..rotateZ(math.pi/4.0),
        );
      else*/
      return Transform(
      origin: Offset( size.height/6.6,size.height/6.6),
        child: Container(
          width: size.height / 3.3,
          height: size.height / 3.3,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: color,
              boxShadow: [BoxShadow(
                blurRadius: 2.0,
              )]),
          child: Transform.rotate(
            angle: -0.8,
            child: child
          ),
        ), 
        transform: Matrix4.translationValues(size.width/10.2, 0, 0)..rotateZ(math.pi/4.0),
        );
  }
}