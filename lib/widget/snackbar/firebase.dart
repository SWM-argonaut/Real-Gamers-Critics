import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:real_gamers_critics/configs/size_config.dart';

import 'package:real_gamers_critics/view/login.dart';

needLoginSnackbar() {
  Get.snackbar("need login".tr, "need login for comment".tr,
      margin: EdgeInsets.symmetric(
          vertical: SizeConfig.defaultSize * 15,
          horizontal: SizeConfig.defaultSize * 3),
      mainButton: TextButton(
          onPressed: () => Get.off(LoginPage()), child: Text("login".tr)),
      snackPosition: SnackPosition.BOTTOM);
}
