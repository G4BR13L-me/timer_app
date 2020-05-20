import 'package:flutter/material.dart';

class Blink extends StatefulWidget {
  final Widget child;

  Blink({@required this.child});

  @override
  _BlinkState createState() => _BlinkState();
}

class _BlinkState extends State<Blink> with SingleTickerProviderStateMixin{
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: Duration(seconds: 1))
    ..addListener(() {
      if(_controller.isCompleted)
        _controller.reverse();
      else if(_controller.isDismissed)
        _controller.forward();
    });

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0
    ).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: Curves.easeInOutSine
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}