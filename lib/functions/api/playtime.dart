import 'package:get/get.dart';

import 'package:real_gamers_critics/blocs/applications_controller.dart';

import 'package:real_gamers_critics/functions/api/base.dart';

class PlaytimeApi {
  static Future<dynamic> updatePlaytime() async {
    // TODO: 여기 api를 인코딩된걸 주지 않고 코드 보고 실패시 다시 전송하도록 만들어야
    return await BaseApi.postWithAuth("playtime", <String, dynamic>{
      "region": "${Get.deviceLocale?.countryCode}",
      "gameList": Map.fromIterable(Get.find<ApplicationsController>().apps,
          key: (a) => a.packageName, value: (a) => a.usage.inSeconds)
    });
  }
}
