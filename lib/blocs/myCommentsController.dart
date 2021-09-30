import 'dart:developer';

import 'package:get/get.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:real_gamers_critics/models/comment.dart';

import 'package:real_gamers_critics/functions/api/comment.dart';

class MyCommentsController extends GetxController {
  List<CommentModel> comments = [];

  void load() async {
    log("load my comments");

    if (FirebaseAuth.instance.currentUser == null) {
      log("fail, need login");
      comments = [];
      update();
      return;
    }

    comments = await CommentApi.getAllMyComments();
    log("my comments :" + comments.toString());
    update();
  }
}
