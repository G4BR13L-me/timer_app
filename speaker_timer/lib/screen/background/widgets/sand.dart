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
      if (height >= -0.6) {
        path.moveTo(0, size.height);
        path.quadraticBezierTo(
            size.width * 0.50, size.height * height, size.width, size.height);
        path.close();
      } else {
        path.moveTo(0, size.height);
        path.quadraticBezierTo(
            size.width * 0.50, size.height * -0.6, size.width, size.height);
        path.close();
        var path2 = Path();
        path2.moveTo(size.width/8.5, size.height/1.5);
        path2.quadraticBezierTo(
            size.width * 0.50, size.height * (height/2.6)*width, 7.5*size.width/8.5, size.height/1.5);
        path2.close();

        //path2.addPolygon([Offset(0,size.height),Offset(size.width,size.height),
        //Offset(width,size.height*height ),Offset(size.width - width,size.height*height)], false);
        path = Path.combine(PathOperation.union, path, path2);
        
        
        /*path.moveTo(0, size.height);
        path.lineTo(size.width, size.height);
        path.lineTo(size.width / 2.0, size.height * height * 0.48);
        path.close();*/
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
}
