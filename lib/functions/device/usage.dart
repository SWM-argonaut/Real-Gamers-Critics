import 'dart:io' show Platform;
import 'package:flutter/services.dart';

import 'package:app_usage/app_usage.dart';

class AppUsageMap {
  static const MethodChannel _methodChannel =
      const MethodChannel("app_usage.methodChannel");

  static Future<List<AppUsageInfo>> getAppUsageMap(
      DateTime startDate, DateTime endDate) async {
    if (!Platform.isAndroid) {
      throw new AppUsageException(
          'AppUsage API exclusively available on Android!');
    }

    /// Convert dates to ms since epoch
    int end = endDate.millisecondsSinceEpoch;
    int start = startDate.millisecondsSinceEpoch;

    /// Set parameters
    Map<String, int> interval = {'start': start, 'end': end};

    /// Get result and parse it as a Map of <String, double>
    Map usage = await _methodChannel.invokeMethod('getUsage', interval);
    Map<String, double> _map = Map<String, double>.from(usage);

    /// Convert each entry in the map to an Application object
    return _map.keys
        .map((k) => AppUsageInfo(k, _map[k]!, startDate, endDate))
        .where((a) => a.usage > Duration(seconds: 0))
        .toList();
  }
}
