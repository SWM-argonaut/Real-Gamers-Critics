import 'dart:developer';

import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:in_app_update/in_app_update.dart';

/// High-priority, request an immediate update.
/// Medium-priority, request a flexible update.
/// Low-priority, nothing.
///
/// 0 <= priority <= 5
class VersionController extends GetxController {
  final int highPriority, mediumPriority;

  VersionController({this.highPriority = 0, this.mediumPriority = 0});

  Future<void> checkForUpdateAndPerform() async {
    if (Platform.isAndroid) {
      await andoridCheckForUpdateAndPerform();
    }

    // if (Platform.isIOS) {} // TODO
  }

  /// for Android Google Playstore
  Future<void> andoridCheckForUpdateAndPerform() async {
    // Each AppUpdateInfo instance can be used to start an update only once.
    AppUpdateInfo _updateInfo = await InAppUpdate.checkForUpdate();

    log(_updateInfo.toString());

    // no update or network error
    if (_updateInfo.updateAvailability ==
        UpdateAvailability.updateNotAvailable) {
      return;
    }

    // High-priority, request an immediate update.
    if (_updateInfo.updatePriority >= highPriority) {
      await InAppUpdate.performImmediateUpdate();

      return;
    }

    // Medium-priority, request a flexible update.
    if (_updateInfo.updatePriority >= mediumPriority) {
      await InAppUpdate.startFlexibleUpdate();
      Get.snackbar("", "An update has just been downloaded.",
          duration: Duration(hours: 1),
          mainButton: TextButton(
              child: Text("RESTART"),
              onPressed: () async {
                await InAppUpdate.completeFlexibleUpdate();
              }));

      return;
    }

    // Low-priority, nothing.
  }
}
