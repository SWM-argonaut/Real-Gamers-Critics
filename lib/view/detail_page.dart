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

import 'package:real_gamers_critics/configs/configs.dart';
import 'package:real_gamers_critics/configs/size_config.dart';

import 'package:real_gamers_critics/blocs/analytics.dart';
import 'package:real_gamers_critics/blocs/myCommentsController.dart';
import 'package:real_gamers_critics/blocs/leaderboardController.dart';
import 'package:real_gamers_critics/blocs/providers/comment_provicer.dart';

import 'package:real_gamers_critics/functions/api/comment.dart';
import 'package:real_gamers_critics/functions/format/number.dart';
import 'package:real_gamers_critics/functions/format/time.dart';
import 'package:real_gamers_critics/functions/playstore/check_app.dart';

import 'package:real_gamers_critics/models/applications.dart';
import 'package:real_gamers_critics/models/comment.dart';

import 'package:real_gamers_critics/widget/likes.dart';
import 'package:real_gamers_critics/widget/network.dart';
import 'package:real_gamers_critics/widget/rating.dart';
import 'package:real_gamers_critics/widget/bottom_sheet/comment.dart';
import 'package:real_gamers_critics/widget/snackbar/warning.dart';

const _topBackroundColor = Color.fromRGBO(46, 33, 85, 0.3);

const _tabFontSize = 2.4;

class TapIndexController extends GetxController {
  RxInt index = 0.obs;
}

class DetailPage extends StatefulWidget {
  final ApplicationInfos app;

  final MyCommentsController myCommentsController = Get.find();
  final LeaderboardController leaderboardController = Get.find();
  final TapIndexController tapIndexController = TapIndexController();

  DetailPage({required this.app, Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // logging
    AnalyticsBloc.onDetail(widget.app);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<CommentProvider>(context, listen: false)
          .fetch(widget.app.packageName);
      widget.leaderboardController.fetch(widget.app.packageName);
    });

    final int _index = widget.myCommentsController.comments.indexWhere(
        (_comment) =>
            _comment.gameIdRegion ==
            "${widget.app.packageName}#${Get.deviceLocale?.countryCode}");

    return Scaffold(
      // AppBar

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

      // Body
      body: Container(
          width: SizeConfig.screenWidth,
          color: _topBackroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 35, child: appInfo(widget.app)),
              // playTime(app),
              Expanded(
                flex: 65,
                child: tap(),
              )
            ],
          )),
      floatingActionButton: reviewButton(widget.app, _index != -1),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Stack appInfo(ApplicationInfos app) {
    return Stack(children: [
      Container(
          width: SizeConfig.screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: SizeConfig.defaultSize * 11,
                margin: EdgeInsets.only(
                  top: SizeConfig.defaultSize * 2,
                  bottom: SizeConfig.defaultSize * 1,
                ),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(SizeConfig.defaultSize * 2.2)),
                child: app.icon != null
                    ? ClipRRect(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.defaultSize),
                        child: Image(
                          image: MemoryImage(app.icon!),
                        ))
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
                    if (app.enabled) {
                      AnalyticsBloc.onPlay(app.packageName);
                      DeviceApps.openApp(app.packageName);
                    } else {
                      // TODO 플레이 스토어 링크 열기
                      log("미설치");
                    }
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
            ],
          )),
      Positioned(
          left: SizeConfig.defaultSize * 2,
          top: SizeConfig.defaultSize * 6,
          child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: Icon(
                    Icons.chevron_left_rounded,
                    color: _topBackroundColor,
                    size: SizeConfig.defaultSize * 3.5,
                  ))))
    ]);
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

  Widget tap() {
    return LayoutBuilder(builder: (context, constraints) {
      return Obx(() => Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            padding: EdgeInsets.only(top: SizeConfig.defaultSize * 0.2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(SizeConfig.defaultSize * 3),
              ),
            ),
            child: Column(children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: () => widget.tapIndexController.index.value = 0,
                        child: Container(
                            padding: EdgeInsets.only(
                                top: SizeConfig.defaultSize * 2),
                            decoration: widget.tapIndexController.index.value ==
                                    0
                                ? BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width:
                                                SizeConfig.defaultSize * 0.2)))
                                : null,
                            child: Text("Reviews".tr,
                                style: TextStyle(
                                  fontSize:
                                      SizeConfig.defaultSize * _tabFontSize,
                                  fontFamily: 'JejuGothic',
                                  height: 1.5,
                                )))),
                    GestureDetector(
                        onTap: () => widget.tapIndexController.index.value = 1,
                        child: Container(
                            padding: EdgeInsets.only(
                                top: SizeConfig.defaultSize * 2),
                            decoration: widget.tapIndexController.index.value ==
                                    1
                                ? BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width:
                                                SizeConfig.defaultSize * 0.2)))
                                : null,
                            child: Text("Leaderboard".tr,
                                style: TextStyle(
                                  fontSize:
                                      SizeConfig.defaultSize * _tabFontSize,
                                  fontFamily: 'JejuGothic',
                                  height: 1.5,
                                ))))
                  ]),
              Expanded(
                  child: [comments(), leaderboard()]
                      .elementAt(widget.tapIndexController.index.value)),
            ]),
          ));
    });
  }

  Widget comments() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Consumer<CommentProvider>(
            builder: (context, commentProvider, child) {
          List<CommentModel>? _comments =
              commentProvider.get(widget.app.packageName);
          if (commentProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          // err
          if (_comments == null) {
            return checkYourNetwork();
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
              height: constraints.maxHeight,
              child: ListView(
                padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 13),
                children: _comments
                    .map((_comment) => commentBuilder(_comment))
                    .toList(),
              ));
        });
      },
    );
  }

  Container commentBuilder(CommentModel comment) {
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
          Container(
              padding: EdgeInsets.only(
                  top: SizeConfig.defaultSize,
                  bottom: SizeConfig.defaultSize * 0.2),
              child: Row(
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
                      Text(" " +
                          "Played:".tr +
                          " ${durationFormat(comment.playTime)}")
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
                  ])),
          Padding(padding: EdgeInsets.all(SizeConfig.defaultSize * 0.3)),
          Text("${comment.longText}"),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text("was this review helpful?".tr),
            Likes(
              on: () {
                CommentApi.addLike(widget.app.packageName, comment.userID!);
                AnalyticsBloc.onLikes(comment);
              },
              offAble: false,
              // TODO off: () => CommentApi.deleteLike(),
              count: comment.likes,
              isOn: comment.likedUser
                      ?.contains(FirebaseAuth.instance.currentUser?.uid) ??
                  false,
            ),
          ]),
        ],
      ),
    );
  }

  Widget leaderboard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GetBuilder<LeaderboardController>(builder: (_) {
          List<CommentModel>? _leaderboards = _.get(widget.app.packageName);
          if (_.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          // err
          if (_leaderboards == null) {
            return checkYourNetwork();
          }
          // if no reviews in there
          else if (_leaderboards.length == 0) {
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
                  "No one in our app played this game\nTake the first step!".tr,
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
              height: constraints.maxHeight,
              child: ListView.builder(
                itemCount: _leaderboards.length,
                padding: EdgeInsets.only(
                    top: SizeConfig.defaultSize * 1.2,
                    bottom: SizeConfig.defaultSize * 13),
                itemExtent: SizeConfig.defaultSize * 9.4,
                itemBuilder: (BuildContext context, int ranking) => Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(
                        vertical: SizeConfig.defaultSize * 0.5,
                        horizontal: SizeConfig.defaultSize * 1),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(105, 105, 105, 0.1),
                        borderRadius:
                            BorderRadius.circular(SizeConfig.defaultSize * 1)),
                    child: ListTile(
                      leading: Container(
                          width: SizeConfig.defaultSize * 4.7,
                          height: SizeConfig.defaultSize * 4.7,
                          padding: EdgeInsets.only(
                              top: ranking == 0
                                  ? SizeConfig.defaultSize * 2.14
                                  : SizeConfig.defaultSize * 1.4),
                          decoration: ranking == 0
                              ? BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/Crown1.png"),
                                      fit: BoxFit.fitHeight))
                              : null,
                          child: Text(
                            "${ranking + 1}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'JejuGothic',
                                fontSize: SizeConfig.defaultSize * 1.8),
                          )),
                      title: Text(
                        _leaderboards[ranking].userName ?? "ANONYMOUS".tr,
                        style: TextStyle(
                            fontFamily: 'JejuGothic',
                            fontSize: SizeConfig.defaultSize * 1.8),
                      ),
                      subtitle: Container(
                          padding: EdgeInsets.only(
                              top: SizeConfig.defaultSize * 0.5),
                          child: Text(
                            _leaderboards[ranking].shortText ??
                                "Not yet commented".tr,
                            style: TextStyle(
                                fontFamily: 'JejuGothic',
                                color: Color.fromRGBO(105, 105, 105, 1),
                                fontSize: SizeConfig.defaultSize * 1.8),
                          )),
                      trailing: Text(
                        "${durationFormat(_leaderboards[ranking].playTime)}",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'JejuGothic',
                            fontSize: SizeConfig.defaultSize * 1.8),
                      ),
                    )),
              ));
        });
      },
    );
  }

  GestureDetector reviewButton(ApplicationInfos app, bool rated) {
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
          (app.usage?.inMinutes ?? 0) < playtimeToLeaveComment
              ? "play ${playtimeToLeaveComment - (app.usage?.inMinutes ?? 0)}min more to rate"
              : rated
                  ? "Modify Review".tr
                  : "Rate & Review".tr,
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
          needLoginSnackbar();
        } else {
          AnalyticsBloc.onReviwButtonClick(app);
          commentBottomSheet(app);
        }
      },
    );
  }
}
