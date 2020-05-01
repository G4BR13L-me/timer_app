import 'package:flutter/material.dart';

class ExpandAnimation extends StatefulWidget {
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
  _ExpandAnimationState createState() => _ExpandAnimationState();
}

class _ExpandAnimationState extends State<ExpandAnimation> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.animation,
        builder: (context, child) {
          return Container(
            height: widget.fixHeight ? widget.height : widget.animation.value,
            width: widget.fixWidth ? widget.width : widget.animation.value,
            child: child,
            padding: EdgeInsets.zero,
          );
        },
        child: widget.child
    );
  }
}