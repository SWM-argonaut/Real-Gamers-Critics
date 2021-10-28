class ApplicationSearchModel {
  String? _title;
  String? _gameId;
  String? _icon;

  ApplicationSearchModel({String? title, String? gameId, String? icon}) {
    this._title = title;
    this._gameId = gameId;
    this._icon = icon;
  }

  String? get title => _title;
  String? get gameId => _gameId;
  String? get icon => _icon;

  ApplicationSearchModel.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _gameId = json['gameId'];
    _icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this._title;
    data['gameId'] = this._gameId;
    data['icon'] = this._icon;
    return data;
  }
}
