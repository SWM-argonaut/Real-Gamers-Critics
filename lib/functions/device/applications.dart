import 'dart:developer';

import 'dart:io' show Platform;

import 'package:flutter/services.dart';

import 'package:app_usage/app_usage.dart';
import 'package:device_apps/device_apps.dart';

import 'package:real_gamers_critics/models/applications.dart';

import 'package:real_gamers_critics/functions/playstore/check_app.dart';

Future<List<ApplicationInfos>> getGameInfos() async {
  if (!Platform.isAndroid) {
    throw new AppUsageException(
        'AppUsage API exclusively available on Android!');
  }

  // const MethodChannel _methodChannel =
  //     const MethodChannel("app_usage.methodChannel");

  List<Application> apps =
      await DeviceApps.getInstalledApplications(includeAppIcons: true);
  List<AppUsageInfo> usages = await getUsageStats();
  List<ApplicationInfos> infos = [];
  List<Future<void>> tasks = [];

  if (usages.length == 0) {
    throw Exception("usage access err");
  }

  // task
  // TODO 속도 이슈 로직 정리하기.
  Future<void> getAppInfo(Application app) async {
    AppUsageInfo? usage;
    try {
      // TODO 맵으로 바꾸기
      usage = usages.firstWhere((a) => a.packageName == app.packageName);
    } catch (e) {}

    if (usage != null) {
      String? _genre = await getGenre(app.packageName);

      if (_genre != "NotGame" && _genre != "UNKNOWN") {
        infos.add(ApplicationInfos(app: app, usage: usage, genre: _genre));
      }
    }
  }

  for (Application app in apps) {
    tasks.add(getAppInfo(app));
  }

  await Future.wait(tasks);

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
    DateTime startDate = start ?? DateTime.now().subtract(Duration(days: 365));

    return AppUsage.getAppUsage(startDate, endDate);
  } on AppUsageException catch (exception) {
    print(exception);
    return [];
  }
}
