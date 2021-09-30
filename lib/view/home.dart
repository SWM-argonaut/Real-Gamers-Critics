import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:real_gamers_critics/configs/size_config.dart';

import 'package:real_gamers_critics/blocs/applicationsController.dart';

import 'package:real_gamers_critics/view/app_list.dart';
import 'package:real_gamers_critics/view/introduction.dart';

import 'package:real_gamers_critics/widget/drawer/home.dart';

import 'package:real_gamers_critics/functions/api/comment.dart';

const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _box = GetStorage();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    if (!_box.hasData("Introduction")) {
      return Introduction();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: SizeConfig.defaultSize * 9,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Your Games".tr,
          style: TextStyle(
              color: Color.fromRGBO(46, 32, 85, 1),
              fontFamily: 'JejuGothic',
              fontSize: SizeConfig.defaultSize * 2.7,
              height: 1.4545454545454546),
        ),
      ),
      endDrawer: Drawer(
        child: HomeDrawer(),
      ),
      body: AppList(),
    );
  }
}
