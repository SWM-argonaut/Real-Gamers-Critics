import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:real_gamers_critics/blocs/one_signal.dart';

import 'package:real_gamers_critics/configs/size_config.dart';

import 'package:real_gamers_critics/functions/auth/google.dart';

class HomeDrawer extends StatefulWidget {
  HomeDrawer({Key? key}) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _header(),
        _logInOut(),
        _onsignalSetting(),
      ],
    );
  }

  Container _header() {
    Widget? _child;
    if (FirebaseAuth.instance.currentUser != null) {
      _child = Container(
          padding: EdgeInsets.only(
              left: SizeConfig.defaultSize * 1.7,
              bottom: SizeConfig.defaultSize * 1),
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                  "${FirebaseAuth.instance.currentUser?.photoURL}"),
              radius: SizeConfig.defaultSize * 4,
            ),
            Container(
              padding: EdgeInsets.only(
                  left: SizeConfig.defaultSize * 1.5,
                  bottom: SizeConfig.defaultSize * 1.9),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${FirebaseAuth.instance.currentUser?.displayName}",
                      style: TextStyle(
                          fontSize: SizeConfig.defaultSize * 2,
                          color: Colors.white),
                    ),
                    Text(
                      "${FirebaseAuth.instance.currentUser?.email}",
                      style: TextStyle(
                          fontSize: SizeConfig.defaultSize * 1.5,
                          color: Colors.white),
                    ),
                  ]),
            ),
          ]));
    }

    return Container(
      height: SizeConfig.defaultSize * 17,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/header_background.jpg"),
              fit: BoxFit.cover)),
      child: _child,
    );
  }

  Container _logInOut() {
    Widget _child;

    if (FirebaseAuth.instance.currentUser == null) {
      _child = SignInButton(
        Buttons.Google,
        onPressed: () {
          signInWithGoogle().then((_) {
            setState(() {
              () async {
                log("${await FirebaseAuth.instance.currentUser?.getIdToken()}");
              }();
            });
          });
        },
      );
    } else {
      _child = ElevatedButton(
        child: Text("logout".tr),
        onPressed: () {
          logOutWithGoogle().then((_) {
            setState(() {});
          });
        },
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.defaultSize * 3,
          horizontal: SizeConfig.defaultSize * 6),
      child: _child,
    );
  }

  Container _onsignalSetting() {
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Text("Allow notifications".tr),
        GetBuilder<OnesignalController>(
          builder: (_) => Switch(
            value: !_.pushDisabled,
            onChanged: (_allow) => _.onesignalSettings(disable: !_allow),
          ),
        ),
      ]),
    );
  }
}
