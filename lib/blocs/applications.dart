import 'package:flutter/cupertino.dart';
import 'package:soma_app_usage/models/applications.dart';

import 'package:soma_app_usage/functions/device/applications.dart';

class InstalledApplicationsBloc {
  static late List<ApplicationInfos> apps;

  static Future<bool> isInit = () async {
    apps = await getAppInfos();

    return true;
  }();
}
