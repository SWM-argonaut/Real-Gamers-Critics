// TODO: appsflyer ios setting is required

import 'package:get/get.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';

import 'package:mixpanel_flutter/mixpanel_flutter.dart';

import 'package:real_gamers_critics/configs/configs.dart';
import 'package:real_gamers_critics/models/applications.dart';
import 'package:real_gamers_critics/models/comment.dart';

class AnalyticsBloc {
  // firebase
  static FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: firebaseAnalytics);
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  // AppsFlyer
  static AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
  // mixpanel
  static late Mixpanel mixpanel;

  static void init() async {
    mixpanel = await Mixpanel.init(
      mixpanelToken,
      optOutTrackingDefault: false,
    );
    String? distinctId = await mixpanel.getDistinctId();
    String? firebaseMessagingToken = await firebaseMessaging.getToken();

    appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true);
    appsflyerSdk.setCustomerUserId(distinctId!);
    appsflyerSdk.updateServerUninstallToken(firebaseMessagingToken!);

    firebaseAnalytics.setUserId(distinctId);
  }

  static _logger({required String name, required Map<String, dynamic> param}) {
    // firebase
    firebaseAnalytics.logEvent(name: name, parameters: param);
    // mixpanel
    mixpanel.track(name, properties: param);
  }

  static onIntro() {
    _logger(name: "인트로페이지_시작", param: <String, dynamic>{
      "지역": "${Get.deviceLocale}",
    });
  }

  static onIntroFinished() {
    _logger(name: "인트로페이지_완료", param: <String, dynamic>{
      "지역": "${Get.deviceLocale}",
    });
  }

  static onGrantpermissionButtonuttonClick() {
    _logger(name: "권한_버튼_클릭", param: <String, dynamic>{
      "지역": "${Get.deviceLocale}",
    });
  }

  static onGrantPermission() {
    _logger(name: "권한_획득", param: <String, dynamic>{
      "지역": "${Get.deviceLocale}",
    });
  }

  static onDismissPermission() {
    _logger(name: "권한_거부됨", param: <String, dynamic>{
      "지역": "${Get.deviceLocale}",
    });
  }

  static installedAppInfo(int totalCount, int gameCount) {
    _logger(name: "설치된_게임앱_정보", param: <String, dynamic>{
      "지역": "${Get.deviceLocale}",
      "전체_앱_수": totalCount,
      "게임앱_수": gameCount,
    });
  }

  static onDetail(ApplicationInfos app) {
    _logger(name: "상세페이지", param: <String, dynamic>{
      "구글_유저_아이디": "${FirebaseAuth.instance.currentUser?.uid ?? '로그인_안함'}",
      "gameId#Region": app.packageName + "${Get.deviceLocale}",
      "플레이_시간": "${app.usage?.inMinutes}Min",
    });
  }

  static onPlay(String packageName) {
    _logger(name: "게임_플레이", param: <String, dynamic>{
      "구글_유저_아이디": "${FirebaseAuth.instance.currentUser?.uid ?? '로그인_안함'}",
      "gameId#Region": packageName + "${Get.deviceLocale}",
    });
  }

  static onLogin() {
    _logger(name: "로그인", param: <String, dynamic>{
      "구글_유저_아이디": "${FirebaseAuth.instance.currentUser?.uid ?? '로그인_안함'}",
    });
  }

  static onLogout() {
    _logger(name: "로그아웃", param: <String, dynamic>{});
  }

  static onReviwButtonClick(ApplicationInfos app) {
    _logger(name: "리뷰버튼눌림", param: <String, dynamic>{
      "구글_유저_아이디": "${FirebaseAuth.instance.currentUser?.uid ?? '로그인_안함'}",
      "gameId#Region": app.packageName + "${Get.deviceLocale}",
      "플레이_시간": "${app.usage?.inMinutes}Min",
    });
  }

  static onReviw(ApplicationInfos app, int rating) {
    _logger(name: "리뷰", param: <String, dynamic>{
      "구글_유저_아이디": "${FirebaseAuth.instance.currentUser?.uid ?? '로그인_안함'}",
      "gameId#Region": app.packageName + "${Get.deviceLocale}",
      "플레이_시간": "${app.usage?.inMinutes}Min",
      "평점": rating,
    });
  }

  static onLikes(CommentModel comment) {
    _logger(name: "좋아요", param: <String, dynamic>{
      "구글_유저_아이디": "${FirebaseAuth.instance.currentUser?.uid ?? '로그인_안함'}",
      "작성자_아이디": comment.userID,
      "작성자의_평점": comment.rating,
      "gameId#Region": comment.gameIdRegion,
    });
  }
}
