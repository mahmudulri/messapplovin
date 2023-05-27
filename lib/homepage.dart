import 'dart:io';
import 'dart:math';

import 'package:applovin_ads/banner.dart';
import 'package:applovin_ads/video.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
  }

  var _interstitialRetryAttempt = 0;
  var _rewardedAdRetryAttempt = 0;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      body: Container(
        color: Colors.black,
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.10,
            ),
            Text(
              "Make Sure your VPN is Connected",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.030,
            ),
            Text(
              "Open Banner Section and keep for 1/2 mins",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.050,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => BannerAds());
                },
                child: Container(
                  height: 60,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Banner Section",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.050,
            ),
            Text(
              "Load Your Video ADS first",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: GestureDetector(
                onTap: () {
                  initializeInterstitialAds();
                },
                child: Container(
                  height: 60,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Load Video Ads",
                      style: TextStyle(
                        color: Colors.cyan,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.050,
            ),
            Text(
              "Play Your Video Now",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Skip Min 5 Ads, & Download 1 game and play the game for 2 min",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: GestureDetector(
                onTap: () async {
                  bool isReady = (await AppLovinMAX.isInterstitialReady(
                      "dcbf056eb70aa1c9"))!;
                  if (isReady) {
                    AppLovinMAX.showInterstitial("dcbf056eb70aa1c9");
                  }
                },
                child: Container(
                  height: 60,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Play Video Ads",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Get.to(() => BannerAds());
            //   },
            //   child: Text("Banner Ads"),
            // ),
            SizedBox(
              height: 20,
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     initializeInterstitialAds();
            //   },
            //   child: Text("Load Video Ads"),
            // ),
            SizedBox(
              height: 20,
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     bool isReady = (await AppLovinMAX.isInterstitialReady(
            //         "dcbf056eb70aa1c9"))!;
            //     if (isReady) {
            //       AppLovinMAX.showInterstitial("dcbf056eb70aa1c9");
            //     }
            //     // Get.to(() => Videoads());
            //   },
            //   child: Text("Video ads"),
            // ),
          ],
        ),
      ),
    ));
  }

  void initializeInterstitialAds() {
    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) {
        // Interstitial ad is ready to be shown. AppLovinMAX.isInterstitialReady(_interstitial_ad_unit_id) will now return 'true'
        print('Interstitial ad loaded from ' + ad.networkName);
        Fluttertoast.showToast(
          msg: "Add loaded",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP_LEFT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // Reset retry attempt
        _interstitialRetryAttempt = 0;
      },
      onAdLoadFailedCallback: (adUnitId, error) {
        // Interstitial ad failed to load
        // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
        _interstitialRetryAttempt = _interstitialRetryAttempt + 1;

        int retryDelay = pow(2, min(6, _interstitialRetryAttempt)).toInt();

        print('Interstitial ad failed to load with code ' +
            error.code.toString() +
            ' - retrying in ' +
            retryDelay.toString() +
            's');

        Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
          AppLovinMAX.loadInterstitial("dcbf056eb70aa1c9");
        });
      },
      onAdDisplayedCallback: (ad) {},
      onAdDisplayFailedCallback: (ad, error) {},
      onAdClickedCallback: (ad) {},
      onAdHiddenCallback: (ad) {},
    ));

    // Load the first interstitial
    AppLovinMAX.loadInterstitial("dcbf056eb70aa1c9");
  }
}
