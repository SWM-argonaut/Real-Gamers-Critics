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

    if (usage != null) infos.add(ApplicationInfos(app: app, usage: usage));
  }

  return infos;
}

/// android only (iOS is not supported).
Future<List<AppUsageInfo>> getUsageStats(
    {DateTime? start, DateTime? end}) async {
  try {
    DateTime endDate = end ?? DateTime.now();
    // 600일 이상으로 넘어가면 일주일 데이터가 나온다 .. 뭐지?
    // getAppUsage 함수는 안드로이드의 queryAndAggregateUsageStats 함수를 사용하는데
    // 이 함수는 플래그로 best interval을 사용하는데 (https://developer.android.com/reference/android/app/usage/UsageStatsManager#queryAndAggregateUsageStats(long,%20long))
    // 이게 문제인가?
    DateTime startDate = start ?? DateTime.now().subtract(Duration(days: 600));

    return AppUsage.getAppUsage(startDate, endDate);
  } on AppUsageException catch (exception) {
    print(exception);
    return [];
  }
}
