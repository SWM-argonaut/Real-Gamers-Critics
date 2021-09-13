import 'dart:typed_data';

import 'package:app_usage/app_usage.dart';
import 'package:device_apps/device_apps.dart';

class ApplicationInfos {
  /// Name of the package
  final String packageName;

  /// Displayable name of the application
  final String appName;

  /// Icon of the application to use in conjunction with [Image.memory]
  final Uint8List? icon;

  /// Full path to the base APK for this application
  final String apkFilePath;

  /// Public name of the application (eg: 1.0.0)
  /// The version name of this package, as specified by the <manifest> tag's
  /// `versionName` attribute
  final String? versionName;

  /// Unique version id for the application
  final int versionCode;

  /// Full path to the default directory assigned to the package for its
  /// persistent data
  final String dataDir;

  /// Whether the application is installed in the device's system image
  /// An application downloaded by the user won't be a system app
  final bool systemApp;

  /// The time at which the app was first installed
  final int installTimeMillis;

  /// The time at which the app was last updated
  final int updateTimeMillis;

  /// The category of this application
  /// The information may come from the application itself or the system
  final ApplicationCategory category;

  /// Whether the app is enabled (installed and visible)
  /// or disabled (installed, but not visible)
  final bool enabled;

  /// The amount of time the application has been used
  /// in the specified interval
  final Duration? usage;

  /// The start of the interval
  final DateTime? startDate;

  /// The end of the interval
  final DateTime? endDate;

  /// genre
  final String? genre;

  ApplicationInfos({AppUsageInfo? usage, required Application app, this.genre})
      : packageName = app.packageName,
        appName = app.appName,
        apkFilePath = app.apkFilePath,
        versionName = app.versionName,
        versionCode = app.versionCode,
        dataDir = app.dataDir,
        systemApp = app.systemApp,
        installTimeMillis = app.installTimeMillis,
        updateTimeMillis = app.updateTimeMillis,
        enabled = app.enabled,
        category = app.category,
        usage = usage?.usage,
        startDate = usage?.startDate,
        endDate = usage?.endDate,
        icon = app is ApplicationWithIcon ? app.icon : null;
}
