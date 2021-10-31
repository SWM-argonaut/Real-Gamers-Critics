import 'dart:developer';

import 'package:get/get.dart';

import 'package:real_gamers_critics/functions/api/application.dart';

import 'package:real_gamers_critics/models/applications.dart';

class ApplicationsSearchController extends GetxController {
  bool _isLoading = false;
  bool _hasError = false;

  Map<String, List<ApplicationInfos>?> _searchdataMap = {};

  get isLoading => _isLoading;
  get hasError => _hasError;

  List<ApplicationInfos>? get(String orderBy) {
    return _searchdataMap[orderBy];
  }

  /// Get data when null.
  void fetch() async {
    if (_searchdataMap["ByReviews"] != null) return;

    _searchdataMap["ByReviews"] =
        await ApplicationApi.getApplicatioListByReviews();
    try {
      _isLoading = true;
      _hasError = false;
      update();

      _searchdataMap["ByReviews"] =
          await ApplicationApi.getApplicatioListByReviews();
    } catch (e) {
      _hasError = true;
      log(e.toString());
    } finally {
      _isLoading = false;
      update();
    }
  }
}
