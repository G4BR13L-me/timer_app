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
            begin: MediaQuery.of(context).size.width / 5.0,
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
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: scrollAnimation.value,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
              color: Color(0xFFEAE9EA),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: controller.isDismissed ? 0 : 300)
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Transform.rotate(
                        angle: arrowAnimation.value,
                        child: Icon(Icons.arrow_right),
                      ),
                      Image.asset(
                        'assets/hourglass_icon.png',
                        width: 30,
                        height: 50,
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: GestureDetector(
                  child: Icon(Icons.timer),
                  onTap: (){
                    //widget.pageController.animateToPage(page, duration: null, curve: null);
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: GestureDetector(
                  child: Icon(Icons.alarm),
                  onTap: (){
                    //widget.pageController.animateToPage(page, duration: null, curve: null);
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: GestureDetector(
                  child: Icon(Icons.hourglass_empty),
                  onTap: (){
                    //widget.pageController.animateToPage(page, duration: null, curve: null);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
