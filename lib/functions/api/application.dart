import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:get/get.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:real_gamers_critics/blocs/applications_controller.dart';

import 'package:real_gamers_critics/configs/configs.dart';
import 'package:real_gamers_critics/functions/api/base.dart';

import 'package:real_gamers_critics/models/application_metadata_model.dart';
import 'package:real_gamers_critics/models/comment.dart';

class ApplicationApi {
  static Future<ApplicationMetadataModel> getApplicationMetadata(
      String packageName) async {
    return ApplicationMetadataModel.fromJson(await BaseApi.get(
      "application/gameID/$packageName",
    ));
  }
}
