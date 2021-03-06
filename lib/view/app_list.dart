import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import 'package:device_apps/device_apps.dart';
import 'package:real_gamers_critics/blocs/analytics.dart';

import 'package:real_gamers_critics/configs/configs.dart'
    show playtimeToLeaveComment;
import 'package:real_gamers_critics/configs/size_config.dart';

import 'package:real_gamers_critics/blocs/my_comments_controller.dart';
import 'package:real_gamers_critics/blocs/applications_controller.dart'
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

        return Container(
            padding: EdgeInsets.only(top: SizeConfig.defaultSize),
            child: ListView(
              padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 9),
              children: appController.apps.map(_itemBuilder).toList(),
            ));
      },
    );
  }
}

Widget _itemBuilder(ApplicationInfos _app) {
  return GetBuilder<MyCommentsController>(
    builder: (_) {
      // 한줄평이 있으면 한줄평을 아니면 플레이 타임
      LinearIndicator _indicator;
      int _index = _.comments.indexWhere((_comment) =>
          _comment.gameIdRegion ==
          "${_app.packageName}#${Get.deviceLocale?.countryCode}");
      if (_index == -1) {
        _indicator = LinearIndicator(
          width: SizeConfig.defaultSize * 24,
          height: SizeConfig.defaultSize * 3,
          percent: _app.usage!.inMinutes / playtimeToLeaveComment,
          text: (_app.usage!.inMinutes < playtimeToLeaveComment
              ? "${_app.usage!.inMinutes}m/${playtimeToLeaveComment}m"
              : "${playtimeToLeaveComment}m/${playtimeToLeaveComment}m"),
        );
      } else {
        _indicator = LinearIndicator(
          width: SizeConfig.defaultSize * 24,
          height: SizeConfig.defaultSize * 3,
          percent: 1.0,
          durationSeconds: 1,
          color: Color.fromRGBO(250, 255, 0, 0.2),
          text: ('"${_.comments[_index].shortText}"'),
          boxBorder: Border.all(width: 0.1, color: Colors.black),
        );
      }

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
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.defaultSize),
                                  child: Image(image: _app.icon!))
                              : Icon(Icons.image_not_supported_outlined),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        if (_app.enabled) {
                                          AnalyticsBloc.onPlay(
                                              _app.packageName);
                                          DeviceApps.openApp(_app.packageName);
                                        } else {
                                          log("미설치");
                                        }
                                        ;
                                      },
                                      label: Text(
                                          _app.enabled
                                              ? 'play'.tr
                                              : 'install'.tr,
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  102, 48, 255, 1))),
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
                            _indicator,
                          ],
                        )
                      ])))));
    },
  );
}
