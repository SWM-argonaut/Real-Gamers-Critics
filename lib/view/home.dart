import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:soma_app_usage/view/login.dart';
import 'package:soma_app_usage/view/app_list.dart';
import 'package:soma_app_usage/configs/size_config.dart';

const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = <Widget>[
    AppList(),
    LoginPage(),
  ];

  final _bottomNavItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'list'.tr,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.login),
      label: 'login'.tr,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: SizeConfig.defaultSize * 9,
        centerTitle: true,
        title: Text("home page".tr),
      ),
      body: _tabs.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
