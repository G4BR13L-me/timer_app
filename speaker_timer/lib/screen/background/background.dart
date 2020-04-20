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
  Animation<double> topSandAnimation;
  Animation<double> bottomSandAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: widget.duration));
    topSandAnimation = Tween<double>(begin: -0.8, end: 1.0).animate(controller);
    bottomSandAnimation =
        Tween<double>(begin: 1.0, end: -0.8).animate(controller);
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

    final Image img = Image.asset(
      MediaQuery.of(context).orientation == Orientation.landscape
          ? 'assets/hourglass_landscape.png'
          : 'assets/hourglass.png',
      fit: BoxFit.fill,
      //width: 2.0 / 3.0 * size.width,
      //height: size.height * 0.8,
    );

    return Consumer<PlayStatus>(
      builder: (context, player, child) {
        if (player.isPlaying) {
          controller.repeat();
        } else {
          controller.stop();
        }
        return SafeArea(
        child: Container(
            color: Colors.white,
            width: size.width,
            height: size.height,
            child: Stack(
              children: <Widget>[
                //CustomAppBar(),

                // TODO: ADD SAND RECT AND DROP EFFECT

                Transform(
                  child: Center(
                    child: SizedBox(
                        width: size.width / 1.5,
                        height: size.height / 2.3,
                        child: CustomPaint(
                            painter: Sand(bottomSandAnimation.value, true))),
                  ),
                  transform: Matrix4.translationValues(
                      size.width / 10.0, size.height / 4.77, 0),
                ),

                Transform(
                  child: Center(
                    child: SizedBox(
                        width: size.width / 1.5,
                        height: size.height / 2.3,
                        child: CustomPaint(
                            painter: Sand(topSandAnimation.value, false))),
                  ),
                  transform: Matrix4.translationValues(
                      size.width / 1.3, size.height / 4.38, 0),
                ),

                Container(
                  height: size.height,
                  width: size.width,
                  padding: EdgeInsets.only(left: size.width * 0.2),
                  child: img,
                ),
                Center(child: Crystal(size.width, size.height,player)),
              ],
            )),
      );
      },
    );
  }
}
