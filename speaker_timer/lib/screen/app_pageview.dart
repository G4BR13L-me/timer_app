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
    //It controls the ads to don't display banners while any timer is running
    bool shouldShowBanner = !((stopWatchStatus?.isPlaying)??true)&&!((timerStatus?.isPlaying)??true);

    return SafeArea(
      child: borderContainer(
        child: Stack(
          children: <Widget>[
            PageView(
              controller: controller,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                borderContainer(
                  child: ChangeNotifierProvider<PlayStatus>(
                    child: Consumer<PlayStatus>(
                      builder: (context,player,child) {
                        timerStatus = player;
                        if(shouldShowBanner)
                          AppAds.showBanner(state: this, anchorOffset: 5.0);
                        else
                          AppAds.removeBanner();
                        return Timer(stopWatchStatus);
                      }),
                    create: (_)=>PlayStatus(),
                  )
                ),
                borderContainer(
                  child: ChangeNotifierProvider<PlayStatus>(
                    child: Consumer<PlayStatus>(
                      builder: (context,player,child) {
                        stopWatchStatus = player;
                        if(shouldShowBanner)
                          AppAds.showBanner(state: this, anchorOffset: 5.0);
                        else
                          AppAds.removeBanner();
                        return Background(timerStatus,'Stopwatch');
                      }),
                    create: (_)=>PlayStatus(),
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