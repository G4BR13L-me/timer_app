import 'package:flutter/material.dart';
import 'package:speaker_timer/screen/background/app_bar.dart';
import 'package:speaker_timer/screen/background/background.dart';
import 'package:speaker_timer/screen/timer/timer_screen.dart';

class AppPageView extends StatefulWidget {
  @override
  _AppPageViewState createState() => _AppPageViewState();
}

class _AppPageViewState extends State<AppPageView> {
  final controller = PageController(initialPage: 2);

  Widget borderContainer({@required Widget child}) => Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: Colors.black54, width: 0.1),
              bottom: BorderSide(color: Colors.black54, width: 0.1))),
      child: child);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          PageView(
            controller: controller,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              borderContainer(
                child: Stack(
                  children: <Widget>[
                    Container(color: Colors.green,),
                    Hero(tag: 'appbar', child: CustomAppBar(controller))
                  ],
                ),
              ),
              borderContainer(
                child: Stack(
                  children: <Widget>[
                    Timer(),
                    Hero(tag: 'appbar', child: CustomAppBar(controller))
                  ],
                ),
              ),
              borderContainer(
                child: Stack(
                  children: <Widget>[
                    Background(),
                    Hero(tag: 'appbar', child: CustomAppBar(controller))
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
