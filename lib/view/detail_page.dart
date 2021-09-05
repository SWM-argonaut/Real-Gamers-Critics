import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:device_apps/device_apps.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:soma_app_usage/configs/size_config.dart';

import 'package:soma_app_usage/models/applications.dart';

class DetailPage extends StatelessWidget {
  final ApplicationInfos app;

  DetailPage({required this.app, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {},
          )
        ],
      ),

      // Body
      body: Container(
          width: SizeConfig.screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...appInfo(app),
              playTime(app),
            ],
          )),

      // FloatingActionButton
      floatingActionButton: FloatingActionButton(
        child: Text("버튼"),
        onPressed: () {},
      ),
    );
  }
}

List<Widget> appInfo(ApplicationInfos app) {
  return [
    Container(
      width: SizeConfig.defaultSize * 11,
      margin: EdgeInsets.only(
        top: SizeConfig.defaultSize * 2,
        bottom: SizeConfig.defaultSize * 1,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.defaultSize * 2.2)),
      child: app.icon != null
          ? Image(
              image: MemoryImage(app.icon!),
            )
          : Icon(Icons.not_accessible),
    ),
    Text(
      "${app.appName}",
      style: TextStyle(
          fontSize: SizeConfig.defaultSize * 2.2, fontWeight: FontWeight.bold),
    ),
    // TODO: 플레이 스토어 데이터를 가져와야 될듯
    Text(
      "${app.versionName}",
      style: TextStyle(fontSize: SizeConfig.defaultSize * 2.2),
    ),

    ElevatedButton(
        onPressed: () {
          DeviceApps.openApp(app.packageName);
        },
        // TODO: https://stackoverflow.com/questions/11753000/how-to-open-the-google-play-store-directly-from-my-android-application
        child: Text("play".tr)),
  ];
}

Container playTime(ApplicationInfos app) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 1),
    child: Column(
      children: [
        // play time info
        Container(alignment: Alignment.centerLeft, child: Text("play time".tr)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: SizeConfig.screenWidth / 2 - 5,
              child: Column(
                children: [Text("total play time".tr), Text("${app.usage}")],
              ),
            ),
            SizedBox(
              width: SizeConfig.screenWidth / 2 - 5,
              child: Column(
                children: [
                  Text("last played date".tr),
                  Text("다른 라이브러리 사용 or 직접") // TODO:
                ],
              ),
            )
          ],
        ),

        // TODO: chart
      ],
    ),
  );
}
