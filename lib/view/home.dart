import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:scroll_navigation/scroll_navigation.dart';

import 'package:real_gamers_critics/configs/configs.dart';
import 'package:real_gamers_critics/configs/size_config.dart';

import 'package:real_gamers_critics/blocs/analytics.dart';
import 'package:real_gamers_critics/blocs/applications_controller.dart';

import 'package:real_gamers_critics/functions/api/comment.dart';

import 'package:real_gamers_critics/view/app_list.dart';
import 'package:real_gamers_critics/view/search_page.dart';
import 'package:real_gamers_critics/view/introduction.dart';

import 'package:real_gamers_critics/widget/ads.dart';
import 'package:real_gamers_critics/widget/drawer/home.dart';

const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _box = GetStorage();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    if (!_box.hasData("Introduction")) {
      return Introduction();
    }

    return Scaffold(
      key: scaffoldKey,
      // appBar: AppBar(
      //   centerTitle: true,
      //   toolbarHeight: SizeConfig.defaultSize * 7,
      //   iconTheme: IconThemeData(color: Colors.black),
      //   title: Text(
      //     "Your Games".tr,
      //     style: TextStyle(
      //         color: Color.fromRGBO(46, 32, 85, 1),
      //         fontFamily: 'JejuGothic',
      //         fontSize: SizeConfig.defaultSize * 2.7,
      //         height: 1.4545454545454546),
      //   ),
      //   // actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      // ),
      drawer: Drawer(
        child: HomeDrawer(),
      ),
      body: SafeArea(
          child: Stack(children: [
        TitleScrollNavigation(
          // initialPage: 1, // TODO 밑에 바가 안 맞음..
          barStyle: TitleNavigationBarStyle(
              elevation: 0,
              padding: EdgeInsets.only(
                  top: SizeConfig.defaultSize * 3,
                  bottom: SizeConfig.defaultSize * 1.5),
              activeColor: Color.fromRGBO(46, 32, 85, 1),
              style: TextStyle(
                  fontFamily: 'JejuGothic',
                  fontSize: SizeConfig.defaultSize * 2.2),
              spaceBetween: SizeConfig.defaultSize * 2.4),
          identiferStyle: NavigationIdentiferStyle(color: Colors.black),
          titles: ["Your Games".tr, "Top Games".tr],
          pages: [AppList(), SearchPage()],
        ),
        Positioned(
          top: SizeConfig.defaultSize * 2,
          left: SizeConfig.defaultSize * 1.5,
          child: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
        ),
        Positioned(
            bottom: 0,
            child: BannerAdWidget(bannerAdUnitId: bottomBannerAdUnitId)),
      ])),
    );
  }
}
