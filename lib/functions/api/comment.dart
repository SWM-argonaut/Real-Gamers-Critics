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

class CommentApi {
  static Future<List<CommentModel>> getAllMyComments() async {
    return List<CommentModel>.from((await BaseApi.getWithAuth(
      "comments/me",
    ))
        .where((_comment) => _comment['createDate'] != null)
        .map((_comment) => CommentModel.fromJson(_comment)));
  }

  static Future<List<CommentModel>> getAllAppComments(
      String packageName) async {
    return List<CommentModel>.from((await BaseApi.get(
      "comments/region/${Get.deviceLocale?.countryCode}/gameID/$packageName",
    ))
        .where((_comment) => _comment['createDate'] != null)
        .map((_comment) => CommentModel.fromJson(_comment)));
  }

  static Future<dynamic> addComment(
      String packageName, String shortText, String longText, int rating) async {
    return await BaseApi.postWithAuth("comment", <String, dynamic>{
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

  static Future<dynamic> addLike(String packageName, String userID) async {
    return await BaseApi.postWithAuth("like", <String, dynamic>{
      "region": "${Get.deviceLocale?.countryCode}",
      "gameID": packageName,
      "target": userID, // target Uid
    });
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
