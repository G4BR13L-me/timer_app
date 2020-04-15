import 'package:flutter/material.dart';
import 'dart:math';

class Sand extends StatelessWidget {
  final AnimationController controller;
  final bool bottom;

  Sand({@required this.controller,@required this.bottom});

  @override
  Widget build(BuildContext context) {
    double totalSum = sum(1.25, 25, 1.25);
    double interval = 1.0/totalSum;
    int index = bottom ? totalSum.round() : 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        // controls the heigth of the triangle
        for (var i = 0; i < 25; i++) 
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // controls the width of the triangle
              for (var j = 0; j < i*1.25; j++)
                _sand(context, bottom ? interval*index-- : interval*(++index),interval, totalSum)
            ],
          ),
      ],
    );
  }

  double sum (double q, double n, double frist){
    return frist*(pow(q, n)-1)/(q-1);
  }

  Widget _sand (BuildContext context, double index, double interval, double sum) {

    Animation<double> animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(parent: controller, curve: Interval(
            index-interval,
            index,
            curve: Curves.ease
          ))
      );

    return FadeTransition(
        child: Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(shape: BoxShape.circle,color: Color(0xFFB66BFF)),
        ), 
        opacity: animation,
    );
  }
}