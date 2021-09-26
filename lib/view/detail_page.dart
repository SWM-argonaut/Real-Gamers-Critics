import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import 'package:intl/intl.dart';

import 'package:device_apps/device_apps.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import 'package:real_gamers_critics/configs/size_config.dart';

import 'package:real_gamers_critics/blocs/analytics.dart';

import 'package:real_gamers_critics/functions/api/comment.dart';
import 'package:real_gamers_critics/functions/format/number.dart';
import 'package:real_gamers_critics/functions/format/time.dart';
import 'package:real_gamers_critics/functions/playstore/check_app.dart';

import 'package:real_gamers_critics/models/applications.dart';
import 'package:real_gamers_critics/models/comment.dart';
import 'package:real_gamers_critics/providers/comment_provicer.dart';

import 'package:real_gamers_critics/widget/likes.dart';
import 'package:real_gamers_critics/widget/rating.dart';
import 'package:real_gamers_critics/widget/comment.dart';

import 'package:real_gamers_critics/view/login.dart';

const _topBackroundColor = Color.fromRGBO(46, 33, 85, 0.3);

class DetailPage extends StatefulWidget {
  final ApplicationInfos app;

  DetailPage({required this.app, Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // logging
    AnalyticsBloc.onDetail(widget.app);

    WidgetsBinding.instance?.addPostFrameCallback((_) =>
        Provider.of<CommentProvider>(context, listen: false)
            .fetch(widget.app.packageName));

    return Scaffold(
      // AppBar
      appBar: AppBar(
        backgroundColor: _topBackroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
        // TODO 나중에 자기 플레이 타임하고 그래프 예쁠때
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       Icons.share,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {},
        //   ),
        //   IconButton(
        //     icon: Icon(
        //       Icons.delete,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {},
        //   )
        // ],
      ),

      // Body
      body: Container(
          width: SizeConfig.screenWidth,
          color: _topBackroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...appInfo(widget.app),
              // playTime(app),
              comments(widget.app),
            ],
          )),
      floatingActionButton: reviewButton(widget.app),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
        color: Colors.white,
        fontSize: SizeConfig.defaultSize * 2.2,
        fontWeight: FontWeight.bold,
      ),
    ),
    GestureDetector(
        onTap: () {
          DeviceApps.openApp(app.packageName);
        },
        // TODO: https://stackoverflow.com/questions/11753000/how-to-open-the-google-play-store-directly-from-my-android-application

        child:
            // Figma Flutter Generator BaseWidget - RECTANGLE
            Container(
                width: SizeConfig.defaultSize * 12,
                height: SizeConfig.defaultSize * 4,
                alignment: Alignment.center,
                margin: EdgeInsets.all(SizeConfig.defaultSize * 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color.fromRGBO(106, 54, 255, 0.1),
                ),
                child: Text(
                  "Play".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(106, 54, 255, 1),
                      fontFamily: 'JejuGothic',
                      fontSize: SizeConfig.defaultSize * 2,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1.5),
                ))),
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

Widget comments(ApplicationInfos app) {
  return Container(
    width: SizeConfig.screenWidth,
    height: SizeConfig.screenHeight,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(SizeConfig.defaultSize * 3),
      ),
    ),
    child: Column(children: [
      Container(
          margin: EdgeInsets.only(top: SizeConfig.defaultSize * 2),
          child: Text("Reviews".tr,
              style: TextStyle(fontSize: SizeConfig.defaultSize * 3))),
      Consumer<CommentProvider>(builder: (context, commentProvider, child) {
        List<CommentModel>? _comments = commentProvider.get(app.packageName);

        if (commentProvider.isLoading) {
          return Container(
              margin: EdgeInsets.only(top: SizeConfig.defaultSize * 20),
              alignment: Alignment.topCenter,
              width: SizeConfig.defaultSize * 3,
              height: SizeConfig.defaultSize * 3,
              child: CircularProgressIndicator());
        }

        // err
        if (_comments == null) {
          // TODO
        }

        // if no reviews in there
        else if (_comments.length == 0) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: SizeConfig.defaultSize * 3,
                    bottom: SizeConfig.defaultSize),
                child: Image(
                  image: AssetImage('assets/images/box.png'),
                  width: SizeConfig.defaultSize * 18,
                ),
              ),
              Text(
                "No one left a review for the game\nTake the first step!".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(105, 105, 105, 1),
                    fontFamily: 'JejuGothic',
                    fontSize: SizeConfig.defaultSize * 2,
                    height: 1.5),
              ),
            ],
          );
        }

        return Container(
            height: SizeConfig.screenHeight,
            child: ListView(
              children: _comments!
                  .map((_comment) => commentBuilder(_comment, app))
                  .toList(),
            ));
      })
    ]),
  );
}

Container commentBuilder(CommentModel comment, ApplicationInfos app) {
  return Container(
    margin: EdgeInsets.all(SizeConfig.defaultSize * 2),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          CircleAvatar(
            backgroundImage: NetworkImage("${comment.photoURL}"),
            radius: SizeConfig.defaultSize * 1.5,
          ),
          Text(
            "  ${comment.userName}",
            style: TextStyle(fontSize: SizeConfig.defaultSize * 2),
          ),
        ]),
        Padding(padding: EdgeInsets.all(SizeConfig.defaultSize * 0.5)),
        Text(
          "${comment.shortText}",
          style: TextStyle(fontSize: SizeConfig.defaultSize * 3),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(children: [
                SvgPicture.asset(
                  "assets/svg/game.svg",
                  semanticsLabel: 'game logo',
                  alignment: Alignment.center,
                  width: SizeConfig.defaultSize * 1.7,
                ),
                Text(
                    " " + "Played:".tr + " ${durationFormat(comment.playTime)}")
              ]),
              Row(children: [
                SvgPicture.asset(
                  "assets/svg/star.svg",
                  semanticsLabel: 'game logo',
                  alignment: Alignment.center,
                  width: SizeConfig.defaultSize * 2,
                ),
                Text(" ${comment.rating}/5 ")
              ]),
              // Text(" ${DateFormat('yy.MM.dd').format(comment.createDate!)}")
            ]),
        Padding(padding: EdgeInsets.all(SizeConfig.defaultSize * 0.3)),
        Text("${comment.longText}"),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text("was this review helpful?".tr),
          Likes(
            on: () => CommentApi.addLike(app.packageName, comment.userID!),
            // TODO off: () => CommentApi.deleteLike(),
            count: comment.likes,
          ),
        ]),
      ],
    ),
  );
}

GestureDetector reviewButton(ApplicationInfos app) {
  return GestureDetector(
    child: // Figma Flutter Generator Rectangle5Widget - RECTANGLE
        Container(
      width: SizeConfig.screenWidth * 0.9,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        color: Color.fromRGBO(106, 54, 255, 1),
      ),
      child: Text(
        'Rate & Review',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'JejuGothic',
            fontSize: SizeConfig.defaultSize * 2.2,
            height: 1.5),
      ),
    ),
    onTap: () {
      if (FirebaseAuth.instance.currentUser == null) {
        Get.snackbar("need login".tr, "need login for comment".tr,
            margin: EdgeInsets.symmetric(
                vertical: SizeConfig.defaultSize * 15,
                horizontal: SizeConfig.defaultSize * 3),
            mainButton: TextButton(
                onPressed: () => Get.off(LoginPage()), child: Text("login".tr)),
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
  );
}
