import 'package:flutter/material.dart';
import 'dart:math';

class Sand extends StatelessWidget {
  final AnimationController controller;
  final bool bottom;

  Sand({@required this.controller,@required this.bottom});

  @override
  Widget build(BuildContext context) {
    double totalSum = sumPA(200, 10, 200);
    double interval = 1.0/totalSum;
    int index = bottom ? totalSum.round() : 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        // controls the heigth of the triangle
        for (var i = 10; i < 200; i=(i+0.5).round()) 
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // controls the width of the triangle
              for (var j = 0; j < i; j++)
                _sand(context, bottom ? interval*index-- : interval*(++index),interval, totalSum)
            ],
          ),
      ],
    );
  }

  double sum (double q, double n, double frist){
    return frist*(pow(q, n)-1)/(q-1);
  }

  double sumPA (double n, double frist,double last){
    return (frist+last)*n/2.0;
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
          height: 1,
          width: 1,
          decoration: BoxDecoration(shape: BoxShape.circle,color: Color(0xFFB66BFF)),
        ), 
        opacity: animation,
    );
  }
}