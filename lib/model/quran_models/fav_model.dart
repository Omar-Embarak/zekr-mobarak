class FavModel {
  final int surahIndex;
  final String reciterName;
  final String url;

  FavModel({
    required this.surahIndex,
    required this.reciterName,
    required this.url,
  });

  Map<String, dynamic> toMap() {
    return {
      'surahIndex': surahIndex,
      'reciterName': reciterName,
      'url': url,
    };
  }

  static FavModel fromMap(Map<String, dynamic> map) {
    return FavModel(
      surahIndex: map['surahIndex'],
      reciterName: map['reciterName'],
      url: map['url'],
    );
  }
}
