import 'package:audio_service/audio_service.dart';
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
    return SafeArea(
      child: borderContainer(
        child: Stack(
          children: <Widget>[
            PageView(
              controller: controller,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                borderContainer(
                  child: ChangeNotifierProvider(
                    child: Consumer<PlayStatus>(
                      builder: (context,player,child) {
                        timerStatus = player;
                        if(!((stopWatchStatus?.isPlaying)??true)&&!((timerStatus?.isPlaying)??true))
                          AppAds.showBanner(state: this, anchorOffset: 5.0);
                        else
                          AppAds.removeBanner();
                        return AudioServiceWidget(child: Timer());
                      }),
                    create: (_)=>PlayStatus(),
                  )
                ),
                borderContainer(
                  child: ChangeNotifierProvider(
                    child: Consumer<PlayStatus>(
                      builder: (context,player,child) {
                        stopWatchStatus = player;
                        if(!((stopWatchStatus?.isPlaying)??true)&&!((timerStatus?.isPlaying)??true))
                          AppAds.showBanner(state: this, anchorOffset: 5.0);
                        else
                          AppAds.removeBanner();
                        return AudioServiceWidget(child: Background());
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