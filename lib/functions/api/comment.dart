import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';

import 'package:real_gamers_critics/configs/configs.dart';

import 'package:real_gamers_critics/models/comment.dart';

class CommentApi {
  static Future<http.Response> getComment() {
    return _postWithAuth(
      "get_detail",
      <String, dynamic>{},
    );
  }

  static Future<http.Response> _postWithAuth(
      String endpoint, Map<String, dynamic> body) async {
    String a = "${await FirebaseAuth.instance.currentUser!.getIdToken()}";

    var response = await http.post(
      Uri.parse("$apiBaseUrl/$endpoint"),
      headers: {"Authorization": "Bearer $a"},
      body: '{"region": "KR", "gameID": "new"}', // TODO:
    );
    print(a);

    log('Response status: ${response.statusCode}');
    log('Response header: ${response.headers}');
    log('Response body: ${response.body}');
    log("response : ${response.request?.headers}");

    return response;
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
