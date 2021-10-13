import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:real_gamers_critics/configs/size_config.dart';

Container checkYourNetwork() {
  return Container(
    alignment: Alignment.center,
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 2),
          child: Icon(
            Icons.wifi_off,
            size: SizeConfig.defaultSize * 8,
          )),
      Text("Check your network".tr,
          style: TextStyle(fontSize: SizeConfig.defaultSize * 3))
    ]),
  );
}
