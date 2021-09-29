import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:real_gamers_critics/functions/api/comment.dart';

import 'package:real_gamers_critics/models/comment.dart';

class CommentProvider extends ChangeNotifier {
  bool _isLoading = false;

  Map<String, List<CommentModel>?> _commentsMap = {};

  get isLoading => _isLoading;
  List<CommentModel>? get(String packageName) {
    return _commentsMap[packageName];
  }

  void fetch(String packageName) async {
    try {
      _isLoading = true;
      notifyListeners();

      _commentsMap[packageName] =
          await CommentApi.getAllAppComments(packageName);
    } catch (e) {
      log(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
