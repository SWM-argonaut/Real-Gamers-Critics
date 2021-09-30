import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:usage_stats/usage_stats.dart';

import 'package:introduction_screen/introduction_screen.dart';

import 'package:real_gamers_critics/configs/size_config.dart';

import 'package:real_gamers_critics/widget/dialog/permission.dart';

import 'package:real_gamers_critics/view/home.dart';

class Introduction extends StatefulWidget {
  const Introduction({Key? key}) : super(key: key);

  @override
  _IntroductionState createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  final _box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: _pageList,
      next: const Icon(Icons.arrow_forward),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      onDone: () async {
        // When done button is press
        if (await UsageStats.checkUsagePermission()) {
          _box.write("Introduction", true);
          Get.offAll(Home());
        } else {
          Get.dialog(UsagePermissionDialog());
        }
      },
    );
  }
}

List<PageViewModel> _pageList = [
  // PageViewModel(
  //   image: Container(
  //     width: SizeConfig.defaultSize * 30,
  //     height: SizeConfig.defaultSize * 30,
  //     color: Colors.amber,
  //     child: Text("이미지 추천 받습니다."),
  //   ),
  //   title: "문구 추천 받습니다.",
  //   body: "영어로 적어야 되는데....",
  // ),
  // PageViewModel(
  //   image: Container(
  //     width: SizeConfig.defaultSize * 30,
  //     height: SizeConfig.defaultSize * 30,
  //     color: Colors.amber,
  //     child: Text("이미지 추천 받습니다."),
  //   ),
  //   title: "문구 추천 받습니다.",
  //   body: "영어로 적어야 되는데....",
  // ),
  PageViewModel(
    image: Container(
      width: SizeConfig.defaultSize * 30,
      height: SizeConfig.defaultSize * 30,
      color: Colors.amber,
      child: Text("이미지 추천 받습니다."),
    ),
    title: "문구 추천 받습니다.",
    bodyWidget: Text("영어로 적어야 되는데...."),
  ),
  PageViewModel(
    image: Image.asset("assets/images/Usage_access1.jpg"),
    title: "허용 부탁드려요!",
    bodyWidget: Column(children: [
      Text("게임의 플레이 시간을 알기 위해서 이 권한이 필요합니다!"),
      Container(
          padding: EdgeInsets.all(SizeConfig.defaultSize * 5),
          child: ElevatedButton(
            onPressed: () => UsageStats.grantUsagePermission(),
            child: Text("접근 허용"),
          ))
    ]),
  ),
];
