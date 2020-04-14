import 'package:flutter/material.dart';
import 'dart:math' as math;

class Crystal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.75,
      origin: Offset(25, 25),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0),color: Colors.yellowAccent),
      ),
    );
  }
}