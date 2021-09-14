// TODO: appsflyer ios setting is required

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';

import 'package:mixpanel_flutter/mixpanel_flutter.dart';

import 'package:real_gamers_critics/configs/configs.dart';
import 'package:real_gamers_critics/models/applications.dart';

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

  static onDetail(ApplicationInfos app) {
    _logger(name: "detail", param: <String, dynamic>{
      "user_id": "${FirebaseAuth.instance.currentUser?.uid}",
      "package_name": app.packageName,
      "play_time": "${app.usage?.inMinutes}Min",
    });
  }
}
