import 'dart:io' show Platform;
import 'package:flutter/services.dart';

import 'package:app_usage/app_usage.dart';
import 'package:device_apps/device_apps.dart';

import 'package:soma_app_usage/models/applications.dart';

Future<List<ApplicationInfos>> getAppInfos() async {
  if (!Platform.isAndroid) {
    throw new AppUsageException(
        'AppUsage API exclusively available on Android!');
  }

  const MethodChannel _methodChannel =
      const MethodChannel("app_usage.methodChannel");

  List<Application> apps =
      await DeviceApps.getInstalledApplications(includeAppIcons: true);
  List<AppUsageInfo> usages = await getUsageStats();
  List<ApplicationInfos> infos = [];

  for (Application app in apps) {
    AppUsageInfo? usage;
    try {
      usage = usages.firstWhere((a) => a.packageName == app.packageName);
    } catch (e) {}

    infos.add(ApplicationInfos(app: app, usage: usage));
  }

  return infos;
}

/// android only (iOS is not supported).
///
/// default is 2000-01-01 to DateTime.now()
Future<List<AppUsageInfo>> getUsageStats(
    {DateTime? start, DateTime? end}) async {
  try {
    DateTime endDate = end ?? DateTime.now();
    DateTime startDate = start ?? DateTime.utc(2000, 01, 01);

    return AppUsage.getAppUsage(startDate, endDate);
  } on AppUsageException catch (exception) {
    print(exception);
    return [];
  }
}
