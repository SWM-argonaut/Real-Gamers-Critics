class CommentModel {
  String? _shortText;
  String? _longText;
  int? _starRate;
  int? _createDate;
  User? _user;
  int? _likes;
  bool? _liked;
  String? _gameIdRegion;

  CommentModel(
      {String? shortText,
      String? longText,
      int? starRate,
      int? createDate,
      User? user,
      int? likes,
      bool? liked,
      String? gameIdRegion}) {
    this._shortText = shortText;
    this._longText = longText;
    this._starRate = starRate;
    this._createDate = createDate;
    this._user = user;
    this._likes = likes;
    this._liked = liked;
    this._gameIdRegion = gameIdRegion;
  }

  String? get shortText => _shortText;
  String? get longText => _longText;
  int? get starRate => _starRate;
  int? get createDate => _createDate;
  User? get user => _user;
  int? get likes => _likes;
  bool? get liked => _liked;
  String? get gameIdRegion => _gameIdRegion;

  CommentModel.fromJson(Map<String, dynamic> json) {
    _shortText = json['shortText'];
    _longText = json['longText'];
    _starRate = json['starRate'];
    _createDate = json['createDate'];
    _user = json['user'] != null ? new User.fromJson(json['user']) : null;
    _likes = json['likes'];
    _liked = json['liked'];
    _gameIdRegion = json['gameIdRegion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shortText'] = this._shortText;
    data['longText'] = this._longText;
    data['starRate'] = this._starRate;
    data['createDate'] = this._createDate;
    if (this._user != null) {
      data['user'] = this._user?.toJson();
    }
    data['likes'] = this._likes;
    data['liked'] = this._liked;
    data['gameIdRegion'] = this._gameIdRegion;
    return data;
  }
}

class User {
  String? _id;
  String? _photoURL;
  int? _playTime;

  User({String? id, String? photoURL, int? playTime}) {
    this._id = id;
    this._photoURL = photoURL;
    this._playTime = playTime;
  }

  String? get id => _id;
  String? get photoURL => _photoURL;
  int? get playTime => _playTime;

  User.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _photoURL = json['photoURL'];
    _playTime = json['playTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['photoURL'] = this._photoURL;
    data['playTime'] = this._playTime;
    return data;
  }
}
