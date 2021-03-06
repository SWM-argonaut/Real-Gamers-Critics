import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:real_gamers_critics/blocs/analytics.dart';

import 'package:usage_stats/usage_stats.dart';
import 'package:device_apps/device_apps.dart';

import 'package:real_gamers_critics/models/applications.dart';

import 'package:real_gamers_critics/widget/dialog/permission.dart';

import 'package:real_gamers_critics/functions/api/comment.dart';
import 'package:real_gamers_critics/functions/api/playtime.dart';
import 'package:real_gamers_critics/functions/playstore/check_app.dart';

enum OrderBy {
  PLAYTIME,
  DATE,
}

class ApplicationsController extends GetxController {
  final _box = GetStorage();

  bool asc = false; // 오름차순
  OrderBy orderBy = OrderBy.PLAYTIME;
  List<ApplicationInfos> _apps = [];

  bool _isLoading = false;
  bool _isCached = false;
  bool _hasError = false;

  List<ApplicationInfos> get apps => UnmodifiableListView(_apps);
  bool get isLoading => _isLoading;
  bool get isCached => _isCached;
  bool get hasError => _hasError;

  void init() {
    // 캐싱된게 있으면 일단 띄워준다.
    _isLoading = true;
    update();

    if (_box.hasData("cachedAppList")) {
      log("read cached app list");
      _apps = List<ApplicationInfos>.from(_box
          .read("cachedAppList")
          .map((_data) => ApplicationInfos.fromJson(_data)));
      _isCached = true;
      _isLoading = false; // tmp TODO 캐시인것도 표시해주면서?
      update();
    }

    fetch();
  }

  void sort() {
    List<int Function(ApplicationInfos, ApplicationInfos)> _compareFuncs = [
      (a, b) => a.usage?.compareTo(b.usage ?? Duration()) ?? -1, // PLAYTIME
      (a, b) =>
          a.installTimeMillis?.compareTo(b.installTimeMillis ?? 0) ??
          -1, // DATE
    ];
    assert(_compareFuncs.length == OrderBy.values.length);

    _apps.sort((a, b) => _compareFuncs[orderBy.index](a, b) * (asc ? 1 : -1));

    update();
  }

  void fetch() async {
    log("app list fetch");

    // TODO 병렬로 실행되도록 수정하기.

    /// app info
    await _appInfoFetch();
    _isCached = false;
    sort(); // sort() has update()
    log("info fetch done");

    /// usage time
    await _usageFetch();
    _isLoading = false;
    sort(); // sort() has update()
    log("usage fetch done");

    /// caching
    _box.write("cachedAppList", _apps.map((_app) => _app.toJson()).toList());
    log("write app list cache");
  }

  Future<void> _appInfoFetch() async {
    List<Future<void>> _tasks = [];
    List<ApplicationInfos> _fetchedList = [];
    List<Application> _installedApps =
        await DeviceApps.getInstalledApplications(includeAppIcons: true);

    // task
    Future<void> getAppInfo(Application _app) async {
      String? _genre = await getGenre(_app.packageName);

      if (_genre != "NotGame" && _genre != "UNKNOWN") {
        _fetchedList.add(ApplicationInfos(app: _app, genre: _genre));
      }
    }

    // add tasks
    for (Application app in _installedApps) {
      _tasks.add(getAppInfo(app));
    }
    // run tasks
    await Future.wait(_tasks);

    _apps = _fetchedList;

    AnalyticsBloc.installedAppInfo(_installedApps.length, _apps.length);
  }

  /// android only (iOS is not supported).
  Future<void> _usageFetch() async {
    // 권한 체크 & 없으면 딜레이후 다시 시도
    while (!(await UsageStats.checkUsagePermission())) {
      // 만약 튜토리얼 중이면 그냥 딜레이만 아니면 팝업
      // 튜토리얼이 끝나면 introduction 파일이 생긴다.
      if (_box.hasData("Introduction") && !(Get.isDialogOpen ?? false)) {
        Get.dialog(UsagePermissionDialog());
      }
    }

    if (Get.isDialogOpen == true) {
      Get.back();
    }

    // 600일 이상으로 넘어가면 일주일 데이터가 나온다 .. 뭐지?
    // getAppUsage 함수는 안드로이드의 queryAndAggregateUsageStats 함수를 사용하는데
    // 이 함수는 플래그로 best interval을 사용하는데 (https://developer.android.com/reference/android/app/usage/UsageStatsManager#queryAndAggregateUsageStats(long,%20long))
    // 이게 문제인가?
    // 조금더 찾아본 결과 그냥 데이터가 없을때 이상하게 나온듯...
    Map<String, UsageInfo> _usages =
        await UsageStats.queryAndAggregateUsageStats(
            DateTime.now().subtract(Duration(days: 365)), DateTime.now());

    _apps.forEach((_app) => _app.updateUsage(_usages[_app.packageName]));

    if (FirebaseAuth.instance.currentUser != null) {
      PlaytimeApi.updatePlaytime();
    }
  }
}
