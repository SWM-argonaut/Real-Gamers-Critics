import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:get/get.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:real_gamers_critics/blocs/applications_controller.dart';

import 'package:real_gamers_critics/configs/configs.dart';

import 'package:real_gamers_critics/models/applications.dart';
import 'package:real_gamers_critics/models/comment.dart';

class BaseApi {
  static Future<dynamic> getS3File(String endpoint) async {
    var response = await http.get(
      Uri.parse("$awsS3BaseUrl/$endpoint"),
    );

    log('Response status: ${response.statusCode}');
    log('Response body: ${response.body}');

    return json.decode(response.body);
  }

  static Future<dynamic> postWithAuth(
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

  static Future<dynamic> get(String endpoint) async {
    var response = await http.get(
      Uri.parse("$apiBaseUrl/$endpoint"),
    );

    log('Response status: ${response.statusCode}');
    log('Response body: ${response.body}');

    return json.decode(response.body);
  }

  static Future<dynamic> getWithAuth(String endpoint) async {
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
