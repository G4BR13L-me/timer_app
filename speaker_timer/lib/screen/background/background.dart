import 'dart:async';
import 'dart:ui' as ui;

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

class _BackgroundState extends State<Background>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: widget.duration));
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

    Image img = Image.asset(
      MediaQuery.of(context).orientation == Orientation.landscape
          ? 'assets/hourglass_Landscape.png'
          : 'assets/hourglass.png',
      width: 2.0 / 3.0 * size.width,
      height: size.height * 0.8,
    );

    return SafeArea(
      child: Container(
          color: Colors.white,
          width: size.width,
          height: size.height,
          child: Stack(
            children: <Widget>[
              CustomAppBar(),
              //Sand(controller: controller, bottom: false,),
              /*Transform.rotate(
                angle: math.pi,
                child: Sand(),
              ),*/
              Container(
                height: 11.0 / 12.0 * size.height,
                width: size.width,
                margin: EdgeInsets.only(
                    left: size.width / 7.0, top: 10, bottom: 10, right: 1),
                child: img,
              ),
              AnimatedOpacity(
                  opacity:
                      Provider.of<PlayStatus>(context).isPlaying ? 1.0 : 0.0,
                  duration: Duration(seconds: 1),
                  child: Wave(size: Size(size.width, 50))),
              Transform.translate(
                child: Crystal(img.width, img.height),
                offset: Offset(img.width/2.0, img.height/2.0),
              ),
            ],
          )),
    );
  }
}
