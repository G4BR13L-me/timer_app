import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:ads/ads.dart';

class AppAds {
  static final String appId = 'ca-app-pub-1748335528077671~7826705008';
  static final String bannerUnitId = 'ca-app-pub-1748335528077671/4218632481';

  static Ads _ads = Ads(
    appId,
      bannerUnitId: bannerUnitId,
      testDevices: ["2DB2658AB246A300348AD3A9BEF2A606"],
      testing: true,
      size: AdSize.banner
  );

  static void showBanner(
          {String adUnitId,
          AdSize size,
          List<String> keywords,
          String contentUrl,
          bool childDirected,
          List<String> testDevices,
          bool testing,
          State state,
          double anchorOffset,
          AnchorType anchorType}) =>
      _ads.showBannerAd(
          adUnitId: adUnitId,
          size: size,
          keywords: keywords,
          contentUrl: contentUrl,
          childDirected: childDirected,
          testDevices: testDevices,
          testing: testing,
          state: state,
          anchorOffset: anchorOffset,
          anchorType: anchorType);

  static void removeBanner() => _ads.removeBannerAd();

  static void dispose() => _ads.dispose();
}