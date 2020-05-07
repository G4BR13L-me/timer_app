import 'package:flutter/material.dart';
import 'package:speaker_timer/screen/background/app_bar.dart';
import 'package:speaker_timer/screen/background/background.dart';

class AppPageView extends StatefulWidget {
  @override
  _AppPageViewState createState() => _AppPageViewState();
}

class _AppPageViewState extends State<AppPageView>{
  final controller = PageController(initialPage: 2);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageView(
        controller: controller,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            color: Colors.green,
          ),
          Container(
            color: Colors.red,
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.black54,width:0.1),
                    bottom: BorderSide(color: Colors.black54,width:0.1))),
            child: Stack(
              children: <Widget>[Background(), CustomAppBar(controller)],
            ),
          ),
        ],
      ),
    );
  }
}