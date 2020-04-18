import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';



class HourglassPainter extends CustomPainter{
  final ui.Image image;
  final Offset center;
  HourglassPainter(this.image,this.center);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero , Paint());

  }

  @override
  bool shouldRepaint(HourglassPainter oldDelegate) => image != oldDelegate.image;
  
}