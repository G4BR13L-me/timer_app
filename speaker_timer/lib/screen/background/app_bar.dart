import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomAppBar extends StatefulWidget {
  final PageController pageController;

  CustomAppBar(this.pageController);
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation scrollAnimation;
  Animation arrowAnimation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    arrowAnimation = Tween<double>(begin: 0, end: -math.pi).animate(
        CurvedAnimation(
            parent: controller,
            curve: Curves.easeOutSine,
            reverseCurve: Curves.easeInSine));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scrollAnimation = Tween<double>(
            begin: MediaQuery.of(context).size.width / 5.5,
            end: MediaQuery.of(context).size.width / 2.0)
        .animate(CurvedAnimation(
            parent: controller,
            curve: Curves.easeOutSine,
            reverseCurve: Curves.easeInSine));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Widget _barButton(IconData icon, int index){
      return Padding(
        padding: EdgeInsets.symmetric(
            vertical: 15, horizontal: controller.isDismissed ? 0 : 20),
        child: GestureDetector(
          child: Icon(icon),
          onTap: () {
            widget.pageController.animateToPage(index,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic);
          },
        ),
      );
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          height: size.height,
          width: scrollAnimation.value,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
              color: Color(0xFFEAE9EA),
              boxShadow: [
                BoxShadow(
                    color: Colors.black54,
                    spreadRadius: controller.isDismissed
                        ? 0
                        : size.width / 1.2)
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: controller.isDismissed
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Transform.rotate(
                        angle: arrowAnimation.value,
                        child: Icon(Icons.arrow_right,color: Color(0xFFDF9595),),
                      ),
                      Image.asset(
                        'assets/hourglass_icon.png',
                        width: size.width/12,
                        height: size.height/14,
                      ),
                    ],
                  ),
                  onTap: () {
                    if (!controller.isCompleted)
                      controller.forward();
                    else
                      controller.reverse();
                  },
                ),
              ),
              Divider(),
              _barButton(Icons.timer, 0),
              _barButton(Icons.alarm, 1),
              _barButton(Icons.hourglass_empty, 2),
            ],
          ),
        );
      },
    );
  }
}