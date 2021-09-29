import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:get_storage/get_storage.dart';

import 'package:app_usage/app_usage.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:device_apps/device_apps.dart';

import 'package:real_gamers_critics/models/applications.dart';

import 'package:real_gamers_critics/functions/playstore/check_app.dart';
import 'package:real_gamers_critics/functions/api/comment.dart';

// TODO: Getx로 바꾸기
class ApplicationsProviders extends ChangeNotifier {
  final _box = GetStorage();
  final List<ApplicationInfos> apps = [];

  void init() {
    // 캐싱된게 있으면 일단 띄워준다.
    if (_box.hasData("cachedAppList")) {
      // _box.read("cachedAppList");
    }

    fetch();
  }

  void fetch() async {
    log("app list fetch");

    /// app info
    _appInfoFetch();
    notifyListeners();

    /// usage time

    _usageFetch();
    if (FirebaseAuth.instance.currentUser != null) {
      CommentApi.updatePlaytime(apps);
    }
  }

  Future<void> _appInfoFetch() async {
    List<Future<void>> _tasks = [];
    List<Application> _installedApps =
        await DeviceApps.getInstalledApplications(includeAppIcons: true);

    // task
    Future<void> getAppInfo(Application _app) async {
      String? _genre = await getGenre(_app.packageName);

      if (_genre != "NotGame" && _genre != "UNKNOWN") {
        apps.add(ApplicationInfos(app: _app, genre: _genre));
      }
    }

    // add tasks
    for (Application app in _installedApps) {
      _tasks.add(getAppInfo(app));
    }
    // run tasks
    await Future.wait(_tasks);
  }

  /// android only (iOS is not supported).
  Future<void> _usageFetch({DateTime? start, DateTime? end}) async {
    try {
      // 권한 체크 & 없으면 딜레이후 다시 시도
      // 만약 튜토리얼 중이면 그냥 딜레이만 아니면 팝업

      // 600일 이상으로 넘어가면 일주일 데이터가 나온다 .. 뭐지?
      // getAppUsage 함수는 안드로이드의 queryAndAggregateUsageStats 함수를 사용하는데
      // 이 함수는 플래그로 best interval을 사용하는데 (https://developer.android.com/reference/android/app/usage/UsageStatsManager#queryAndAggregateUsageStats(long,%20long))
      // 이게 문제인가?
      // 조금더 찾아본 결과 그냥 데이터가 없을때 이상하게 나온듯...
      await AppUsage.getAppUsage(
          DateTime.now().subtract(Duration(days: 365)), DateTime.now());
      // TODO 지금 여기부분 다른 라입러리 포팅해서 직접 깃에 만드는중...

    } on AppUsageException catch (exception) {
      log(exception.toString());
    }
  }
}
