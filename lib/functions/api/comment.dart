import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:get/get.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:real_gamers_critics/configs/configs.dart';

import 'package:real_gamers_critics/models/applications.dart';
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
    return List<CommentModel>.from((await _get(
      "comments/region/${Get.deviceLocale?.countryCode}/gameID/$packageName",
    ))
        .where((_comment) => _comment['createDate'] != null)
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
      "userName": FirebaseAuth.instance.currentUser!.displayName,
      "photoURL":
          FirebaseAuth.instance.currentUser!.photoURL, // TODO: userPhotoURL
    });
  }

  static Future<dynamic> updatePlaytime(List<ApplicationInfos> apps) async {
    // TODO: 여기 api를 인코딩된걸 주지 않고 코드 보고 실패시 다시 전송하도록 만들어야
    return await _postWithAuth("playtime", <String, dynamic>{
      "region": "${Get.deviceLocale?.countryCode}",
      "gameList": Map.fromIterable(apps,
          key: (a) => a.packageName, value: (a) => a.usage.inSeconds)
    });
  }

  static Future<dynamic> addLike(String packageName, String userID) async {
    return await _postWithAuth("like", <String, dynamic>{
      "region": "${Get.deviceLocale?.countryCode}",
      "gameID": packageName,
      "target": userID, // target Uid
    });
  }

  static Future<dynamic> _postWithAuth(
      String endpoint, Map<String, dynamic> body) async {
    String auth = "${await FirebaseAuth.instance.currentUser!.getIdToken()}";

    log(json.encode(body));

    var response = await http.post(
      Uri.parse("$apiBaseUrl/$endpoint"),
      headers: {"Authorization": "Bearer $auth"},
      body: json.encode(body),
    );

    log('Response status: ${response.statusCode}');
    log('Response body: ${response.body}');

    return json.decode(response.body);
  }

  static Future<dynamic> _get(String endpoint) async {
    var response = await http.get(
      Uri.parse("$apiBaseUrl/$endpoint"),
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
