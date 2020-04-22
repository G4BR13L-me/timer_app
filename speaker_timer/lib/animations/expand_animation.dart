import 'package:flutter/material.dart';

class ExpandAnimation extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;
  final double height;
  final double width;
  final bool fixHeight;
  final bool fixWidth;

  ExpandAnimation({@required this.child, @required this.animation, 
                  this.height=30, this.width=30, 
                  this.fixHeight = false, this.fixWidth = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Container(
            height: fixHeight ? height : animation.value,
            width: fixWidth ? width : animation.value,
            child: child,
            padding: EdgeInsets.zero,
          );
        },
        child: child
    );
  }
}