import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:real_gamers_critics/configs/configs.dart';
import 'package:real_gamers_critics/configs/languages.dart' as Ln;

import 'package:real_gamers_critics/blocs/analytics.dart';
import 'package:real_gamers_critics/blocs/one_signal.dart';
import 'package:real_gamers_critics/blocs/version_controller.dart';
import 'package:real_gamers_critics/blocs/my_comments_controller.dart';
import 'package:real_gamers_critics/blocs/leaderboard_controller.dart';
import 'package:real_gamers_critics/blocs/applications_controller.dart';
import 'package:real_gamers_critics/blocs/application_search_controller.dart';
import 'package:real_gamers_critics/blocs/applications_metadata_controller.dart';
import 'package:real_gamers_critics/blocs/providers/comment_provicer.dart';

Future<bool> initialization() async {
  await Firebase.initializeApp();
  await GetStorage.init();
  await AnalyticsBloc.init();
  OnesignalController.initOneSignal();
  MobileAds.instance.initialize();

  getxInitialization();

  return true;
}

void getxInitialization() {
  Get.put(LeaderboardController());
  Get.put(ApplicationsSearchController());
  Get.put(ApplicationsMetadataController());
  Get.put(MyCommentsController()).load();
  Get.put(ApplicationsController()).init();
  Get.put(VersionController()).checkForUpdateAndPerform();
  Get.put(OnesignalController()).fetchDeviceState();
}
