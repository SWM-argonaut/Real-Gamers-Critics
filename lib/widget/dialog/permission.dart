import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:real_gamers_critics/configs/size_config.dart';

import 'package:usage_stats/usage_stats.dart';

class UsagePermissionDialog extends StatelessWidget {
  const UsagePermissionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
      alignment: Alignment.center,
      height: SizeConfig.defaultSize * 20,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeConfig.defaultSize * 20)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("need access to get playtime".tr),
        ElevatedButton(
            onPressed: () {
              UsageStats.grantUsagePermission();
              Get.back();
            },
            child: Text("go to settings".tr))
      ]),
    ));
  }
}
