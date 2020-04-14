import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speaker_timer/controller/status.dart';
import 'package:speaker_timer/screen/background/widgets/app_bar.dart';
import 'package:speaker_timer/screen/background/widgets/crystal.dart';
import 'package:speaker_timer/screen/background/widgets/sand.dart';
import 'package:speaker_timer/screen/background/widgets/wave.dart';
import 'dart:math' as math;

class Background extends StatefulWidget {

  final int duration = 20;

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> with SingleTickerProviderStateMixin{

  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(seconds: widget.duration));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        color: Colors.white,
        width: size.width,
        height: size.height,
        child: Stack(
          children: <Widget>[
            CustomAppBar(),
            Sand(controller: controller, bottom: true,),
            /*Transform.rotate(
              angle: math.pi,
              child: Sand(),
            ),*/
            /*Container(
              height: 11.0/12.0*size.height,
              width: size.width,
              margin: EdgeInsets.only(left: 50),
              child: Image.asset('assets/hourglass.png',fit: BoxFit.fill),
            ),*/
            AnimatedOpacity(
            opacity: Provider.of<PlayStatus>(context).isPlaying ? 1.0 : 0.0,
            duration: Duration(seconds: 1),
            child: Wave(size: Size(size.width, 50))),
            Center(child: Crystal()),
            

          ],
        )
      ),
    );
  }
}
