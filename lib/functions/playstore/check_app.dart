import 'package:http/http.dart' as http;

const String playStoreBaseUrl =
    "https://play.google.com/store/apps/details?id=";

const List<String> gameCategory = [
  "Action",
  "Adventure",
  "Arcade",
  "Board",
  "Card",
  "Casino",
  "Casual",
  "Educational",
  "Music",
  "Puzzle",
  "Racing",
  "Role Playing",
  "Simulation",
  "Sports",
  "Strategy",
  "Trivia",
  "Word",
];

/// ex) appId = com.yodo1.crossyroad
Future<bool> isGame(String appId) async {
  // TODO 단순 문자열 서치라서 개선하는게 좋을듯. 근데 다 js 라서 모르겠다.

  var response = await http.get(Uri.parse(playStoreBaseUrl + appId));

  print("Response status: ${response.statusCode}");
  print("Response body: ${response.body}");

  for (String _category in gameCategory) {
    if (response.body.contains(_category)) {
      return true;
    }
  }

  return false;
}
