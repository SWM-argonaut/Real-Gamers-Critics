import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:usage_stats/usage_stats.dart';

import 'package:introduction_screen/introduction_screen.dart';

import 'package:real_gamers_critics/configs/size_config.dart';

import 'package:real_gamers_critics/blocs/analytics.dart';

import 'package:real_gamers_critics/widget/dialog/permission.dart';

import 'package:real_gamers_critics/view/home.dart';

class Introduction extends StatefulWidget {
  const Introduction({Key? key}) : super(key: key);

  @override
  _IntroductionState createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  final _box = GetStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AnalyticsBloc.onIntro();
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: _pageList,
      next: const Icon(Icons.arrow_forward),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      onDone: () async {
        // When done button is press
        if (await UsageStats.checkUsagePermission()) {
          _box.write("Introduction", true);
          AnalyticsBloc.onIntroFinished();
          AnalyticsBloc.onGrantPermission();
          Get.offAll(() => Home());
        } else {
          Get.dialog(UsagePermissionDialog());
        }
      },
    );
  }
}

List<PageViewModel> _pageList = [
  PageViewModel(
    image: Container(
        width: SizeConfig.defaultSize * 30,
        height: SizeConfig.defaultSize * 30,
        child: Image.asset("assets/images/intro1.png")),
    titleWidget: Container(
        padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 1.3),
        child: Text(
          "Play Time Analysis".tr,
          style: TextStyle(
              fontSize: SizeConfig.defaultSize * 4,
              fontWeight: FontWeight.bold),
        )),
    bodyWidget: Text(
      "Check time you played &\nCompare with other gamers".tr,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: SizeConfig.defaultSize * 2.5),
    ),
  ),
  PageViewModel(
    image: Container(
        width: SizeConfig.defaultSize * 30,
        height: SizeConfig.defaultSize * 30,
        child: Image.asset("assets/images/intro2.png")),
    titleWidget: Container(
        padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 1.3),
        child: Text(
          "Game Reviews".tr,
          style: TextStyle(
              fontSize: SizeConfig.defaultSize * 4,
              fontWeight: FontWeight.bold),
        )),
    bodyWidget: Text(
      "Review a mobile game &\nAdd trust with time played".tr,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: SizeConfig.defaultSize * 2.5),
    ),
  ),
  PageViewModel(
    image: Container(
        width: SizeConfig.defaultSize * 30,
        height: SizeConfig.defaultSize * 30,
        child: Image.asset("assets/images/intro3.png")),
    titleWidget: Container(
        padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 1.3),
        child: Text(
          "Permission Please!".tr,
          style: TextStyle(
              fontSize: SizeConfig.defaultSize * 4,
              fontWeight: FontWeight.bold),
        )),
    bodyWidget: Column(children: [
      Text(
        "Please grant permission\nto access your usage data".tr,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: SizeConfig.defaultSize * 2.5),
      ),
      Container(
          padding: EdgeInsets.all(SizeConfig.defaultSize * 5),
          child: ElevatedButton(
            onPressed: () {
              AnalyticsBloc.onGrantpermissionButtonuttonClick();
              UsageStats.grantUsagePermission();
            },
            child: Text("GRANT PERMISSION".tr),
          ))
    ]),
  ),
];
