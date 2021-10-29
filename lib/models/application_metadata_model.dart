class ApplicationMetadataModel {
  String? _title;
  String? _gameId;
  String? _icon;
  List<String>? _screenshots;
  String? _category;
  int? _reviewCount;
  String? _summary;

  ApplicationMetadataModel(
      {String? title,
      String? gameId,
      String? icon,
      List<String>? screenshots,
      String? category,
      int? reviewCount,
      String? summary}) {
    this._title = title;
    this._gameId = gameId;
    this._icon = icon;
    this._screenshots = screenshots;
    this._category = category;
    this._reviewCount = reviewCount;
    this._summary = summary;
  }

  String? get title => _title;
  String? get gameId => _gameId;
  String? get icon => _icon;
  List<String>? get screenshots => _screenshots;
  String? get category => _category;
  int? get reviewCount => _reviewCount;
  String? get summary => _summary;

  ApplicationMetadataModel.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _gameId = json['gameID'];
    _icon = json['icon'];
    _screenshots = json['screenshotURLs'].cast<String>();
    _category = json['category'];
    _reviewCount = json['reviewCount'];
    _summary = json['summary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this._title;
    data['gameID'] = this._gameId;
    data['icon'] = this._icon;
    data['screenshotURLs'] = this._screenshots;
    data['category'] = this._category;
    data['reviewCount'] = this._reviewCount;
    data['summary'] = this._summary;
    return data;
  }
}
