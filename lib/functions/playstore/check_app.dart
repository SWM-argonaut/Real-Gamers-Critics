import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:get_storage/get_storage.dart';

import 'package:real_gamers_critics/configs/configs.dart';

// 2021년 플레이스토어 기준
const List<String> gameCategory = [
  "ACTION",
  "ADVENTURE",
  "ARCADE",
  "BOARD",
  "CARD",
  "CASINO",
  "CASUAL",
  "EDUCATIONAL",
  "MUSIC",
  "PUZZLE",
  "RACING",
  "ROLE_PLAYING",
  "SIMULATION",
  "SPORTS",
  "STRATEGY",
  "TRIVIA",
  "WORD",
];

/// ex) appId = com.yodo1.crossyroad
///
/// If the app isn't a game, return null
///
/// if the app isn't in the playstore, return "UNKNOWN"
// TODO: local storage
Future<String?> getGenre(String appId) async {
  final _box = GetStorage();

  if (_box.hasData(appId)) {
    return _box.read(appId);
  }

  try {
    var response = await http.get(Uri.parse(playStoreBaseUrl + appId));

    log("Response status: ${response.statusCode}");

    if (response.statusCode != 200) {
      // TODO 예외처리 해야되나?
      if (response.statusCode == 404) {
        // 404 일때만 캐싱
        _box.write(appId, "UNKNOWN");
      }
      return "UNKNOWN";
    }

    int index = response.body.indexOf('"genre"');
    String genreField = response.body.substring(index + 20, index + 55);
    log(genreField);

    index = genreField.indexOf("GAME_");
    if (index == -1) {
      _box.write(appId, "NotGame");
      return "NotGame";
    }

    // add key
    String _result = genreField.substring(index + 5, genreField.indexOf('"'));
    _box.write(appId, _result);
    return _result;
  } catch (e) {
    log(e.toString());
    return "NetworkError";
  }
}

// /// ex) appId = com.yodo1.crossyroad
// ///
// /// if the app isn't in the playstore, throw Exception("Not Founded")
// Future<bool> isGame(String appId) async {
//   var response = await http.get(Uri.parse(playStoreBaseUrl + appId));

//   log("Response status: ${response.statusCode}");
//   if (response.statusCode == 404) {
//     throw Exception("Not Founded");
//   }
//   int index = response.body.indexOf('"genre"');
//   String genreField = response.body.substring(index + 20, index + 55);
//   log(genreField);

//   return genreField.contains("GAME_");
// }
