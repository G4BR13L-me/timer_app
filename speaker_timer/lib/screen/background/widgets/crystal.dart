import 'package:flutter/material.dart';
import 'dart:math' as math;

class Crystal extends StatelessWidget {
  Crystal(this.width,this.height);
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.75,
      origin: Offset(width/8.0, height/16.0),
      child: Container(
        width: width/4.0,
        height: height/8.0,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0),color: Color(0xFFB66BFF)),
      ),
    );
  }
}