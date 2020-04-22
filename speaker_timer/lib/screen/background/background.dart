import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speaker_timer/controller/status.dart';
import 'package:speaker_timer/screen/background/widgets/app_bar.dart';
import 'package:speaker_timer/screen/background/widgets/crystal.dart';
import 'package:speaker_timer/screen/background/widgets/sand.dart';
import 'package:speaker_timer/screen/background/widgets/sand_fall.dart';

class Background extends StatefulWidget {
  final int duration = 20;

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> heightSandTranslation;
  Animation<double> heightSandAnimation;
  Animation<double> topSandAnimation;
  Animation<double> bottomSandAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: widget.duration));
    heightSandAnimation = Tween<double>(begin: 1.0, end:0.25).animate(controller);
    heightSandTranslation = Tween<double>(begin: -0.4, end:-1.2).animate(controller);
    bottomSandAnimation =
        Tween<double>(begin: 1.0, end: -0.9).animate(controller);
    controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    topSandAnimation = Tween<double>(begin: 0, end:MediaQuery.of(context).size.width/6.0).animate(controller);
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
        } else if (player.reset) {
          controller.reset();
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

                  AnimatedBuilder(
                    animation: bottomSandAnimation,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            size.width / 10.0, size.height / 4.77, 0),
                        child: Center(
                          child: SizedBox(
                            width: size.width / 1.5,
                            height: size.height / 2.3,
                            child: ClipPath(
                              clipper: Sand(bottomSandAnimation.value, true),
                              child: Image.asset(
                                'assets/sand.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  AnimatedBuilder(
                    animation: topSandAnimation,
                    builder: (BuildContext context, Widget child) {
                      return RotatedBox(
                        quarterTurns: 2,
                        child: Transform(
                          transform: Matrix4.translationValues(
                              -size.width / 10.0, size.height / 4.77*heightSandAnimation.value, 0),
                          child: Center(
                            child: SizedBox(
                              width: size.width / 1.5,
                              height: size.height / 2.3*heightSandAnimation.value,
                              child: ClipPath(
                                clipper: Sand(heightSandTranslation.value, false,width: topSandAnimation.value),
                                child: Image.asset(
                                  'assets/sand.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  Container(
                    height: size.height,
                    width: size.width,
                    padding: EdgeInsets.only(left: size.width * 0.2),
                    child: img,
                  ),
                  Center(child: Crystal(size.width, size.height, player)),
                ],
              )),
        );
      },
    );
  }
}
