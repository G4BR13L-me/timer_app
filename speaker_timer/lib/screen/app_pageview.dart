import 'package:flutter/material.dart';
import 'package:speaker_timer/screen/background/background.dart';
import 'package:speaker_timer/screen/background/widgets/app_bar.dart';

class AppPageView extends StatefulWidget {
  @override
  _AppPageViewState createState() => _AppPageViewState();
}

class _AppPageViewState extends State<AppPageView> {

  final controller = PageController(
    initialPage: 0
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageView(
        controller: controller,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Stack(children: <Widget>[
            Background(),
            CustomAppBar(controller)
          ],),
          Container(color: Colors.green,),
          Container(color: Colors.red,),
        ],
      ),
    );
  }
}