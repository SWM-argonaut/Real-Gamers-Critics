import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:usage_stats/usage_stats.dart';

import 'package:real_gamers_critics/configs/size_config.dart';

import 'package:real_gamers_critics/blocs/analytics.dart';

class UsagePermissionDialog extends StatelessWidget {
  const UsagePermissionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.all(SizeConfig.defaultSize * 1.5),
          child: Image.asset("assets/images/intro3.png")),
      Container(
          padding: EdgeInsets.all(SizeConfig.defaultSize * 3),
          child: Text(
            "Permission Please!".tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: SizeConfig.defaultSize * 4,
              fontWeight: FontWeight.bold,
            ),
          )),
      Container(
          padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 5),
          child: ElevatedButton(
            onPressed: () {
              AnalyticsBloc.onGrantpermissionButtonuttonClick();
              UsageStats.grantUsagePermission();
            },
            child: Text("GRANT PERMISSION".tr),
          ))
    ])
        //     Container(
        //   alignment: Alignment.center,
        //   height: SizeConfig.defaultSize * 20,
        //   decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(SizeConfig.defaultSize * 20)),
        //   child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        //     Text("need access to get playtime".tr),
        //     ElevatedButton(
        //         onPressed: () {
        //           UsageStats.grantUsagePermission();
        //           Get.back();
        //         },
        //         child: Text("go to settings".tr))
        //   ]),
        // )
        );
  }
}
