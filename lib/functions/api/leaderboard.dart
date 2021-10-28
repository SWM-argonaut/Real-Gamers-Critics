import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:get/get.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:real_gamers_critics/blocs/applications_controller.dart';

import 'package:real_gamers_critics/configs/configs.dart';
import 'package:real_gamers_critics/functions/api/base.dart';

import 'package:real_gamers_critics/models/applications.dart';
import 'package:real_gamers_critics/models/comment.dart';

class LeaderboardApi {
  static Future<List<CommentModel>> getLeaderboard(String packageName) async {
    return List<CommentModel>.from((await BaseApi.get(
      "leaderboard/region/${Get.deviceLocale?.countryCode}/gameID/$packageName",
    ))
        .map((_comment) => CommentModel.fromJson(_comment)));
  }
}
