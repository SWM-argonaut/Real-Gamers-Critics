import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import 'package:device_apps/device_apps.dart';

import 'package:real_gamers_critics/configs/configs.dart'
    show playtimeToLeaveComment;
import 'package:real_gamers_critics/configs/size_config.dart';

import 'package:real_gamers_critics/blocs/myCommentsController.dart';
import 'package:real_gamers_critics/blocs/applicationsController.dart'
    show ApplicationsController, ApplicationsProviders;

import 'package:real_gamers_critics/models/applications.dart';

import 'package:real_gamers_critics/functions/format/time.dart';
import 'package:real_gamers_critics/functions/api/comment.dart';

import 'package:real_gamers_critics/view/home.dart';
import 'package:real_gamers_critics/view/detail_page.dart';

import 'package:real_gamers_critics/widget/indicator.dart';

class AppList extends StatelessWidget {
  const AppList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ApplicationsController>(
      builder: (appController) {
        if (appController.hasError) {
          return Center(child: Text("err".tr));
        }
        if (appController.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (appController.apps.length == 0) {
          return Center(
            child: Text("no games".tr),
          );
        }

        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              toolbarHeight: SizeConfig.defaultSize * 9,
              title: Text(
                "Your Games".tr,
                style: TextStyle(
                    color: Color.fromRGBO(46, 32, 85, 1),
                    fontFamily: 'JejuGothic',
                    fontSize: SizeConfig.defaultSize * 2.7,
                    height: 1.4545454545454546),
              ),
            ),
            body: ListView(
              children: appController.apps.map(_itemBuilder).toList(),
            ));
      },
    );
  }
}

Widget _itemBuilder(ApplicationInfos _app) {
  return Align(
      child: GestureDetector(
          onTap: () {
            Get.to(() => DetailPage(app: _app));
          },
          child: SizedBox(
              width: SizeConfig.defaultSize * 40,
              child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(SizeConfig.defaultSize * 2),
                  ),
                  child: Row(children: [
                    // icon
                    Container(
                      width: SizeConfig.defaultSize * 10,
                      margin: EdgeInsets.only(
                          top: SizeConfig.defaultSize * 2,
                          left: SizeConfig.defaultSize * 1,
                          right: SizeConfig.defaultSize * 2.5,
                          bottom: SizeConfig.defaultSize * 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              SizeConfig.defaultSize * 2.2)),
                      child: _app.icon != null
                          ? Image(
                              image: MemoryImage(_app.icon!),
                            )
                          : Icon(Icons.not_accessible),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: SizeConfig.defaultSize * 24,
                            margin: EdgeInsets.only(
                                right: SizeConfig.defaultSize * 0.5,
                                bottom: SizeConfig.defaultSize * 0.5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    child: Text('${_app.appName}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.defaultSize * 2,
                                            fontWeight: FontWeight.bold))),
                                ActionChip(
                                  onPressed: () {
                                    // TODO: https://stackoverflow.com/questions/11753000/how-to-open-the-google-play-store-directly-from-my-android-application
                                    _app.enabled
                                        ? DeviceApps.openApp(_app.packageName)
                                        : log("미설치");
                                  },
                                  label: Text(
                                      _app.enabled ? 'play'.tr : 'install'.tr,
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(102, 48, 255, 1))),
                                  backgroundColor:
                                      Color.fromRGBO(240, 235, 255, 1),
                                ),
                              ],
                            )),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                "assets/svg/game.svg",
                                semanticsLabel: 'game logo',
                                alignment: Alignment.center,
                                width: SizeConfig.defaultSize * 2,
                              ),
                              Text(" " +
                                  "Played".tr +
                                  " : ${durationFormat(_app.usage)}\n")
                            ]), // TODO: tr
                        LinearIndicator(
                          width: SizeConfig.defaultSize * 24,
                          percent:
                              _app.usage!.inMinutes / playtimeToLeaveComment,
                          text:
                              "${_app.usage!.inMinutes < playtimeToLeaveComment ? _app.usage!.inMinutes : playtimeToLeaveComment}m/${playtimeToLeaveComment}m",
                        ),
                      ],
                    )
                  ])))));
}

// Obx(() {
//                           String _text = _myComments.comments.value
//                                   .singleWhere((_comment) =>
//                                       _comment.gameIdRegion ==
//                                       "${_app.packageName}#${Get.deviceLocale?.countryCode}")
//                                   .shortText ??
//                               (_app.usage!.inMinutes < playtimeToLeaveComment
//                                   ? "${_app.usage!.inMinutes}"
//                                   : "${playtimeToLeaveComment}m/${playtimeToLeaveComment}m");

//                           return LinearIndicator(
//                               width: SizeConfig.defaultSize * 24,
//                               percent: _app.usage!.inMinutes /
//                                   playtimeToLeaveComment,
//                               text: _text);
//                         }),