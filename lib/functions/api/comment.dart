import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:get/get.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:real_gamers_critics/configs/configs.dart';

import 'package:real_gamers_critics/models/comment.dart';

class CommentApi {
  static Future<List<CommentModel>> getAllMyComments() async {
    return List<CommentModel>.from((await _getWithAuth(
      "comments/me",
    ))
        .map((_comment) => CommentModel.fromJson(_comment)));
  }

  static Future<List<CommentModel>> getAllAppComments(
      String packageName) async {
    return List<CommentModel>.from((await _getWithAuth(
      "comments/region/${Get.deviceLocale?.countryCode}/gameID/$packageName",
    ))
        .map((_comment) => CommentModel.fromJson(_comment)));
  }

  static Future<dynamic> addComment(
      String packageName, String shortText, String longText, int rating) async {
    return await _postWithAuth("comment", <String, dynamic>{
      "region": "${Get.deviceLocale?.countryCode}",
      "gameID": packageName,
      "rating": rating,
      "shortText": shortText,
      "longText": longText,
      "photoURL": FirebaseAuth.instance.currentUser!.photoURL,
    });
  }

  static Future<dynamic> updatePlaytime() async {
    return await _postWithAuth("playtime", <String, dynamic>{
      "region": "${Get.deviceLocale?.countryCode}",
      "gameList": {
        // TODO:
        "new": 1092843,
        "test": 1029349,
        "sample": 2934859,
      }
    });
  }

  static Future<dynamic> addLike() async {
    return await _postWithAuth("like", <String, dynamic>{
      "region": "${Get.deviceLocale?.countryCode}",
      "gameID": "sample",
      "target": "quartzes", // target Uid
    });
  }

  static Future<dynamic> _postWithAuth(
      String endpoint, Map<String, dynamic> body) async {
    String auth = "${await FirebaseAuth.instance.currentUser!.getIdToken()}";

    var response = await http.post(
      Uri.parse("$apiBaseUrl/$endpoint"),
      headers: {"Authorization": "Bearer $auth"},
      body: json.encode(body),
    );

    log('Response status: ${response.statusCode}');
    log('Response body: ${response.body}');

    return json.decode(response.body);
  }

  static Future<dynamic> _getWithAuth(String endpoint) async {
    String auth = "${await FirebaseAuth.instance.currentUser!.getIdToken()}";

    var response = await http.get(
      Uri.parse("$apiBaseUrl/$endpoint"),
      headers: {"Authorization": "Bearer $auth"},
    );

    log('Response status: ${response.statusCode}');
    log('Response body: ${response.body}');

    return json.decode(response.body);
  }
}

// class CommentApi extends GetConnect {
//   @override
//   void onInit() {
//     httpClient.baseUrl = apiBaseUrl;

//     httpClient.addAuthenticator<dynamic>((request) async {
//       // 헤더 설정
//       request.headers['Authorization'] =
//           "Bearer ${await FirebaseAuth.instance.currentUser!.getIdToken()}";
//       return request;
//     });
//   }

//   Future<Response<Map<String, dynamic>>> getComments() {
//     Future<Response<Map<String, dynamic>>> res = post(
//         "https://1uuazp5ev1.execute-api.us-east-1.amazonaws.com",
//         <String, dynamic>{"hi": "hi"});
//     return res;
//   }
// }
