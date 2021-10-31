class ApplicationSearchModel {
  String? _title;
  String? _gameId;
  String? _iconUrl;
  String? _category;

  ApplicationSearchModel({String? title, String? gameId, String? icon}) {
    this._title = title;
    this._gameId = gameId;
    this._iconUrl = icon;
  }

  String? get title => _title;
  String? get gameId => _gameId;
  String? get iconUrl => _iconUrl;
  String? get category => _category;

  ApplicationSearchModel.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _gameId = json['gameId'];
    _iconUrl = json['icon'];
    _category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this._title;
    data['gameId'] = this._gameId;
    data['icon'] = this._iconUrl;
    data['category'] = this._category;
    return data;
  }
}
