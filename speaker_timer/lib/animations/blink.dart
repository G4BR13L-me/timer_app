import 'package:flutter/material.dart';

class Blink extends StatefulWidget {
  final Widget child;
  final AnimationController controller;

  Blink({@required this.child,this.controller});

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
      begin: 1.0,
      end: 0.2
    ).animate(
      CurvedAnimation(
        parent: widget.controller??_controller, 
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