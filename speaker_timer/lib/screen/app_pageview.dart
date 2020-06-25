import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speaker_timer/controller/ad_mob.dart';
import 'package:speaker_timer/controller/status.dart';
import 'package:speaker_timer/screen/background/app_bar.dart';
import 'package:speaker_timer/screen/background/background.dart';
import 'package:speaker_timer/screen/timer/timer_screen.dart';

class AppPageView extends StatefulWidget {
  @override
  AppPageViewState createState() => AppPageViewState();
}

class AppPageViewState extends State<AppPageView> {
  final controller = PageController(initialPage: 1);

  PlayStatus timerStatus;
  PlayStatus stopWatchStatus;

  @override
  void initState() {
    super.initState();
    timerStatus = PlayStatus();
    stopWatchStatus = PlayStatus();
  }

  @override
  void dispose() {
    controller.dispose();
    AppAds.dispose();
    super.dispose();
  }

  Widget borderContainer({@required Widget child}) => Container(
    height: double.infinity,
    width: double.infinity,
    decoration: BoxDecoration(
        border: Border(
            top: BorderSide(color: Colors.black54, width: 0.1),
            bottom: BorderSide(color: Colors.black54, width: 0.08))),
    child: child);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: borderContainer(
        child: Stack(
          children: <Widget>[
            PageView(
              controller: controller,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                borderContainer(
                  child: ChangeNotifierProvider<PlayStatus>.value(
                    child: Timer(stopWatchStatus),
                    value: timerStatus,
                  )
                ),
                borderContainer(
                  child: ChangeNotifierProvider<PlayStatus>.value(
                      child: Background(timerStatus, 'Stopwatch'),
                    value: stopWatchStatus,
                  )
                ),
              ],
            ),
            Hero(tag: 'appbar', child: CustomAppBar(controller)),
          ],
        ),
      ),
    );
  }
}