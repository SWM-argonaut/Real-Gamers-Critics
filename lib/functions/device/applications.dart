import 'dart:io' show Platform;
import 'package:flutter/services.dart';

import 'package:usage_stats/usage_stats.dart';
import 'package:device_apps/device_apps.dart';

import 'package:soma_app_usage/models/applications.dart';

Future<List<ApplicationInfos>> getAppInfos() async {
  if (!Platform.isAndroid) {
    throw new Exception('AppUsage API exclusively available on Android!');
  }

  List<Application> apps =
      await DeviceApps.getInstalledApplications(includeAppIcons: true);
  List<UsageInfo> usages = await UsageStats.queryUsageStats(
      DateTime.now().subtract(Duration(days: 365)), DateTime.now());
  List<ApplicationInfos> infos = [];

  for (Application app in apps) {
    UsageInfo? usage;
    try {
      usage = usages.firstWhere((a) => a.packageName == app.packageName);
    } catch (e) {}

    if (usage != null) infos.add(ApplicationInfos(app: app, usage: usage));
  }

  return infos;
}
