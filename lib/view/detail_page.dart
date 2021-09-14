import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:intl/intl.dart';

import 'package:device_apps/device_apps.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:real_gamers_critics/configs/size_config.dart';

import 'package:real_gamers_critics/functions/api/comment.dart';
import 'package:real_gamers_critics/functions/playstore/check_app.dart';

import 'package:real_gamers_critics/models/applications.dart';
import 'package:real_gamers_critics/models/comment.dart';

import 'package:real_gamers_critics/widget/comment.dart';
import 'package:real_gamers_critics/widget/rating.dart';

import 'package:real_gamers_critics/view/login.dart';

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
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...appInfo(app),
              playTime(app),
              //
              Container(
                  margin: EdgeInsets.only(left: SizeConfig.defaultSize),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "reviews".tr,
                    style: TextStyle(fontSize: SizeConfig.defaultSize * 2),
                  )),
              comments(app),
            ],
          ))),

      // FloatingActionButton
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.comment),
        onPressed: () {
          if (FirebaseAuth.instance.currentUser == null) {
            Get.snackbar("need login".tr, "need login for comment".tr,
                margin: EdgeInsets.symmetric(
                    vertical: SizeConfig.defaultSize * 15,
                    horizontal: SizeConfig.defaultSize * 3),
                mainButton: TextButton(
                    onPressed: () => Get.to(LoginPage()),
                    child: Text("login".tr)),
                snackPosition: SnackPosition.BOTTOM);
          } else {
            Get.bottomSheet(
                CommentWriting(
                  app: app,
                ),
                enableDrag: false,
                ignoreSafeArea: false,
                isScrollControlled: true);
          }
        },
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
      "${app.genre}".tr,
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
        // Container(alignment: Alignment.centerLeft, child: Text("play time".tr)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: SizeConfig.screenWidth / 2 - 5,
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.all(SizeConfig.defaultSize * 5),
                      child: Text("total play time".tr)),
                  Text(
                    "${app.usage}".split(".").first,
                    style: TextStyle(fontSize: SizeConfig.defaultSize * 5),
                  )
                ],
              ),
            ),
            // SizedBox(
            //   width: SizeConfig.screenWidth / 2 - 5,
            //   child: Column(
            //     children: [
            //       Text("last played date".tr),
            //       Text("다른 라이브러리 사용 or 직접") // TODO:
            //     ],
            //   ),
            // )
          ],
        ),

        // TODO: chart
      ],
    ),
  );
}

FutureBuilder comments(ApplicationInfos app) {
  return FutureBuilder<List<CommentModel>>(
    future: CommentApi.getAllAppComments(app.packageName),
    builder:
        (BuildContext context, AsyncSnapshot<List<CommentModel>> snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text("comment err".tr));
      }
      if (!snapshot.hasData) {
        return Container();
      }

      return Container(
          height: SizeConfig.screenHeight,
          child: ListView(
            children: snapshot.data!.map(commentBuilder).toList(),
          ));
    },
  );
}

Container commentBuilder(CommentModel comment) {
  return Container(
    margin: EdgeInsets.all(SizeConfig.defaultSize * 2),
    child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO : 꾸미기
            CircleAvatar(
              backgroundImage: NetworkImage("${comment.photoURL}"),
            ),
            // TODO : 닉네임?
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              StarRatingReadOnly(
                comment.rating ?? 0,
                size: SizeConfig.defaultSize * 3,
              ),
              Text(" ${DateFormat('yy.MM.dd').format(comment.createDate!)}")
            ]),
            Text(
              "${comment.shortText}",
              style: TextStyle(fontSize: SizeConfig.defaultSize * 2),
            ),
            Text("${comment.longText}"),
          ],
        )),
  );
}
