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
  /*
  static Ads appAds;
  static final String appId = 'ca-app-pub-1748335528077671~7826705008';
  static final String bannerUnitId = 'ca-app-pub-1748335528077671/4218632481';*/

  @override
  void dispose() {
    controller.dispose();
    AppAds.dispose();
    super.dispose();
  }
/*
  @override
  void initState() {
    super.initState();

    appAds = Ads(
      appId,
      bannerUnitId: bannerUnitId,
      testDevices: ["2DB2658AB246A300348AD3A9BEF2A606"],
      testing: true,
      size: AdSize.banner
    );
  }*/

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
                        return Timer();
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
                        return Background();
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