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
          "no games": "설치된 게임이 없습니다.",

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
          "Play": "시작",
          "install": "설치",
          "play time": "플레이 시간",
          "total play time": "총 플레이 시간",
          "reviews": "평점 및 리뷰",
          "need login to see comments": "댓글을 보기 위해선 로그인 해야합니다.",

          // 댓글 페이지
          "need login": "로그인이 필요합니다.",
          "need login for comment": "댓글을 달기 위해선 로그인이 필요합니다.",
          "comment": "댓글",
          "before review": "리뷰는 공개되며 플레이 타임등의 정보를 포함합니다.",
          "short comment": "한줄평",
          "comment more info": "추가 정보 제공하기(선택 사항)",
          "long comment": "상세평(선택)",
          "send comment": "게시",
          "need more play time": "플레이 타임이 부족합니다.",

          // 장르
          "ACTION": "액션",
          "ADVENTURE": "어드벤쳐",
          "ARCADE": "아케이드",
          "BOARD": "보드게임",
          "CARD": "카드",
          "CASINO": "카지노",
          "CASUAL": "캐주얼",
          "EDUCATIONAL": "교육",
          "MUSIC": "음악",
          "PUZZLE": "퍼즐",
          "RACING": "레이싱",
          "ROLE_PLAYING": "롤플레잉",
          "SIMULATION": "시뮬레이션",
          "SPORTS": "스포츠",
          "STRATEGY": "전략",
          "TRIVIA": "퀴즈",
          "WORD": "단어",
          "null": "게임이 아닙니다",
          "UNKNOWN": "플레이스토어에 없는 앱입니다",
        }
      };
}
