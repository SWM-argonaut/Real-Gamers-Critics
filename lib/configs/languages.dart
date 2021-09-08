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
          // 에러
          "err": "뭔가 잘못됨...",
          "Firebase Error": "파이어베이스 연동에 실패했습니다.",

          // 버튼
          "confirm": "확인",
          "Go to login": "로그인 하러 가기",

          // 메인 페이지
          "home page": "내 게임들",

          // 바텀 네비바
          "list": "리스트",
          "login": "로그인",

          // 리스트 페이지
          "need access": "권한이 필요합니다",
          "need access to get playtime": "앱의 사용시간을 표시하기 위해 권한이 필요합니다.",
          "reload": "재시작",

          //디테일 페이지
          "play": "시작",
          "install": "설치",
          "play time": "플레이 시간",
          "total play time": "총 플레이 시간",

          // 댓글 페이지
          "need login": "로그인이 필요합니다.",
          "need login for comment": "댓글을 달기 위해선 로그인이 필요합니다.",
          "comment": "댓글",
          "before review": "리뷰는 공개되며 플레이 타임등의 정보를 포함합니다.",
          "short comment": "한줄평",
          "comment more info": "추가 정보 제공하기(선택 사항)",
          "long comment": "상세평(선택)",
          "send comment": "게시",
        }
      };
}
