import 'package:get/get.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:real_gamers_critics/configs/configs.dart';

class OnesignalController extends GetxController {
  OSDeviceState? _state;

  OneSignal get oneSignal => OneSignal.shared;

  bool get pushDisabled => _state?.pushDisabled ?? true;

  static Future<void> initOneSignal() async {
    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId(oneSignalAppId);

    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
  }

  void fetchDeviceState() async {
    _state = await OneSignal.shared.getDeviceState();
  }

  void onesignalSettings({bool disable = false}) {
    OneSignal.shared.disablePush(disable);
    _state?.pushDisabled = disable;
    update();
  }
}
