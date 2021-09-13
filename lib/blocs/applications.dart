import 'dart:developer';

import 'package:real_gamers_critics/models/applications.dart';

import 'package:real_gamers_critics/functions/device/applications.dart';

// TODO: Getx로 바꾸기
class InstalledApplicationsBloc {
  static late List<ApplicationInfos> apps;

  static bool _isInit = false;

  static Future<bool> init() async {
    if (!_isInit) {
      log("app list init");
      apps = await getGameInfos();
      _isInit = apps.length != 0;
    }

    return _isInit;
  }
}
