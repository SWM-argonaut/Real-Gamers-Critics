import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:real_gamers_critics/configs/configs.dart';

Future<void> initOneSignal() async {
  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId(oneSignalAppId);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
}
