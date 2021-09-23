import 'dart:developer';

import 'package:flutter/services.dart';

checkUsagePermission() async {
  const MethodChannel _methodChannel =
      const MethodChannel("app_usage.methodChannel");

  log((await _methodChannel.invokeMethod('handlePermissions')).toString());
  return await _methodChannel.invokeMethod('handlePermissions');
}
