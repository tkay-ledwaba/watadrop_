import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:watadrop/common/style.dart';

loadBannerAdWidget(bannerAd, isAdLoaded) {

  return Container(
    width: double.infinity,
    height: 64,
    color: colorPrimary,
    child: Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(
          width: bannerAd.size.width.toDouble(),
          height: bannerAd.size.height.toDouble(),
          child: AdWidget(ad: bannerAd),
        )
    ),
  );
}