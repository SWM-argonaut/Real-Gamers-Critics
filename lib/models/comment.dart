class CommentModel {
  String? _shortText;
  String? _longText;
  int? _rating;
  DateTime? _createDate;
  String? _userID;
  String? _photoURL;
  int? _playTime; // 단위 : 초
  int? _likes;
  bool? _liked;
  String? _gameIdRegion;

  CommentModel(
      {String? shortText,
      String? longText,
      int? rating,
      DateTime? createDate,
      int? likes,
      bool? liked,
      String? gameIdRegion,
      String? userID,
      String? photoURL,
      int? playTime}) {
    this._shortText = shortText;
    this._longText = longText;
    this._rating = rating;
    this._createDate = createDate;
    this._userID = userID;
    this._photoURL = photoURL;
    this._playTime = playTime;
    this._likes = likes;
    this._liked = liked;
    this._gameIdRegion = gameIdRegion;
  }

  String? get shortText => _shortText;
  String? get longText => _longText;
  int? get rating => _rating;
  DateTime? get createDate => _createDate;
  String? get userID => _userID;
  String? get photoURL => _photoURL;
  int? get playTime => _playTime;
  int? get likes => _likes;
  bool? get liked => _liked;
  String? get gameIdRegion => _gameIdRegion;

  CommentModel.fromJson(Map<String, dynamic> json) {
    _shortText = json['shortText'];
    _longText = json['longText'];
    _rating = json['rating'];
    _createDate =
        DateTime.fromMillisecondsSinceEpoch(json['createDate'] * 1000);
    _userID = json['userID'];
    _photoURL = json['photoURL'];
    _playTime = json['playTime'];
    _likes = json['likes'];
    _liked = json['liked'];
    _gameIdRegion = json['gameIdRegion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shortText'] = this._shortText;
    data['longText'] = this._longText;
    data['rating'] = this._rating;
    data['createDate'] = this._createDate;
    data['userID'] = this._userID;
    data['photoURL'] = this._photoURL;
    data['playTime'] = this._playTime;
    data['likes'] = this._likes;
    data['liked'] = this._liked;
    data['gameIdRegion'] = this._gameIdRegion;
    return data;
  }
}