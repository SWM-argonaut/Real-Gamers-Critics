import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:real_gamers_critics/view/login.dart';
import 'package:real_gamers_critics/view/app_list.dart';
import 'package:real_gamers_critics/configs/size_config.dart';

import 'package:real_gamers_critics/functions/api/comment.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CommentApi.addLike();
        },
      ),

      //
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
