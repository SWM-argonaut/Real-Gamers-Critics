import 'dart:developer';

import 'package:get/get.dart';

import 'package:real_gamers_critics/functions/api/application.dart';

import 'package:real_gamers_critics/models/application_metadata_model.dart';

class ApplicationsMetadataController extends GetxController {
  bool _isLoading = false;

  Map<String, ApplicationMetadataModel?> _metadataMap = {};

  get isLoading => _isLoading;

  ApplicationMetadataModel? get(String packageName) {
    return _metadataMap[packageName];
  }

  void fetch(String packageName) async {
    try {
      _isLoading = true;
      update();

      _metadataMap[packageName] =
          await ApplicationApi.getApplicationMetadata(packageName);
    } catch (e) {
      log(e.toString());
    } finally {
      _isLoading = false;
      update();
    }
  }
}
