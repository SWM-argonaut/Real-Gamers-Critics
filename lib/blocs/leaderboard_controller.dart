import 'dart:developer';

import 'package:get/get.dart';

import 'package:real_gamers_critics/functions/api/leaderboard.dart';

import 'package:real_gamers_critics/models/comment.dart';

class LeaderboardController extends GetxController {
  bool _isLoading = false;

  // 현재 리더보드 데이터가 댓글 데이터와 같음
  Map<String, List<CommentModel>?> _leaderboardMap = {};

  get isLoading => _isLoading;

  List<CommentModel>? get(String packageName) {
    return _leaderboardMap[packageName];
  }

  void fetch(String packageName) async {
    try {
      _isLoading = true;
      update();

      _leaderboardMap[packageName] =
          await LeaderboardApi.getLeaderboard(packageName);
    } catch (e) {
      log(e.toString());
    } finally {
      _isLoading = false;
      update();
    }
  }
}
