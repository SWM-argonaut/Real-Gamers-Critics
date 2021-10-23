import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:usage_stats/usage_stats.dart';
import 'package:device_apps/device_apps.dart';

class ApplicationInfos {
  /// Name of the package
  String _packageName;

  /// Displayable name of the application
  String _appName;

  /// Icon of the application to use in conjunction with [Image.memory]
  Uint8List? _icon;

  /// Full path to the base APK for this application
  String _apkFilePath;

  /// Public name of the application (eg: 1.0.0)
  /// The version name of this package, as specified by the <manifest> tag's
  /// `versionName` attribute
  String? _versionName;

  /// Unique version id for the application
  int _versionCode;

  /// Full path to the default directory assigned to the package for its
  /// persistent data
  String _dataDir;

  /// Whether the application is installed in the device's system image
  /// An application downloaded by the user won't be a system app
  bool _systemApp;

  /// The time at which the app was first installed
  int _installTimeMillis;

  /// The time at which the app was last updated
  int _updateTimeMillis;

  /// The category of this application
  /// The information may come from the application itself or the system
  ApplicationCategory? _category;

  /// Whether the app is enabled (installed and visible)
  /// or disabled (installed, but not visible)
  bool _enabled;

  /// genre
  String? _genre;

  /// The amount of time the application has been used
  /// in the specified interval
  Duration? _usage;

  /// The start of the interval
  DateTime? _firstTimeStamp;

  /// The end of the interval
  DateTime? _lastTimeStamp;

  DateTime? _lastTimeUsed;

  Duration? get usage => _usage;
  DateTime? get firstTimeStamp => _firstTimeStamp;
  DateTime? get lastTimeStamp => _lastTimeStamp;
  DateTime? get lastTimeUsed => _lastTimeUsed;
  String get packageName => _packageName;
  String get appName => _appName;
  String get apkFilePath => _apkFilePath;
  String get dataDir => _dataDir;
  String? get versionName => _versionName;
  String? get genre => _genre;
  Uint8List? get icon => _icon;
  int get versionCode => _versionCode;
  int get installTimeMillis => _installTimeMillis;
  int get updateTimeMillis => _updateTimeMillis;
  bool get systemApp => _systemApp;
  bool get enabled => _enabled;
  ApplicationCategory? get category => _category;

  ApplicationInfos(
      {required Application app, UsageInfo? usageInfo, String? genre})
      : _packageName = app.packageName,
        _appName = app.appName,
        _apkFilePath = app.apkFilePath,
        _versionName = app.versionName,
        _versionCode = app.versionCode,
        _dataDir = app.dataDir,
        _systemApp = app.systemApp,
        _installTimeMillis = app.installTimeMillis,
        _updateTimeMillis = app.updateTimeMillis,
        _enabled = app.enabled,
        _category = app.category,
        _usage = usageInfo?.totalTimeInForeground ?? Duration(seconds: 0),
        _firstTimeStamp = usageInfo?.firstTimeStamp,
        _lastTimeStamp = usageInfo?.lastTimeStamp,
        _lastTimeUsed = usageInfo?.lastTimeUsed,
        _genre = genre,
        _icon = app is ApplicationWithIcon ? app.icon : null;

  ApplicationInfos.fromJson(Map<String, dynamic> json)
      : this._packageName = json['packageName'],
        this._appName = json['appName'],
        this._apkFilePath = json['apkFilePath'],
        this._versionName = json['versionName'],
        this._versionCode = json['versionCode'],
        this._dataDir = json['dataDir'],
        this._systemApp = json['systemApp'],
        this._installTimeMillis = json['installTimeMillis'],
        this._updateTimeMillis = json['updateTimeMillis'],
        this._enabled = json['enabled'],
        // this._category = json['category'],
        this._usage = Duration(seconds: json['usage'] ?? 0),
        this._firstTimeStamp =
            DateTime.fromMillisecondsSinceEpoch(json['firstTimeStamp'] ?? 0),
        this._lastTimeStamp =
            DateTime.fromMillisecondsSinceEpoch(json['lastTimeStamp'] ?? 0),
        this._lastTimeUsed =
            DateTime.fromMillisecondsSinceEpoch(json['lastTimeUsed'] ?? 0),
        this._genre = json['genre'],
        this._icon = json['icon'] != null ? base64.decode(json['icon']) : null;

  void updateUsage(UsageInfo? usageInfo) {
    if (usageInfo != null) {
      _usage = usageInfo.totalTimeInForeground;
      _firstTimeStamp = usageInfo.firstTimeStamp;
      _lastTimeStamp = usageInfo.lastTimeStamp;
      _lastTimeUsed = usageInfo.lastTimeUsed;
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['packageName'] = this._packageName;
    data['appName'] = this._appName;
    data['apkFilePath'] = this._apkFilePath;
    data['versionName'] = this._versionName;
    data['versionCode'] = this._versionCode;
    data['dataDir'] = this._dataDir;
    data['systemApp'] = this._systemApp;
    data['installTimeMillis'] = this._installTimeMillis;
    data['updateTimeMillis'] = this._updateTimeMillis;
    data['enabled'] = this._enabled;
    // data['category'] = this._category;
    data['usage'] = this._usage?.inSeconds;
    data['firstTimeStamp'] = this._firstTimeStamp?.millisecondsSinceEpoch;
    data['lastTimeStamp'] = this._lastTimeStamp?.millisecondsSinceEpoch;
    data['lastTimeUsed'] = this._lastTimeUsed?.millisecondsSinceEpoch;
    data['genre'] = this._genre;
    data['icon'] = this._icon != null ? base64.encode(this._icon!) : null;
    return data;
  }
}
