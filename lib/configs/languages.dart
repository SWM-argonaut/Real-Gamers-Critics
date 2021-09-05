import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          // err
          "Firebase Error": "Firebase Error",

          // page
          "home page": "Your games",
        },
        'ko_KR': {
          // err
          "err": "뭔가 잘못됨...",
          "Firebase Error": "파이어베이스 연동에 실패했습니다.",

          // page
          "home page": "내 게임들",

          // bottom nav bar
          "list": "리스트",
          "login": "로그인",

          //
          "play": "시작",
        }
      };
}
