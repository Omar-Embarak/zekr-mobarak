class FavModel {
  final int? id;
  final String surahName;
  final String reciterName;
  final String url;

  FavModel({this.id, required this.surahName, required this.reciterName, required this.url});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'surahName': surahName,
      'reciterName': reciterName,
      'url': url,
    };
  }

  static FavModel fromMap(Map<String, dynamic> map) {
    return FavModel(
      id: map['id'],
      surahName: map['surahName'],
      reciterName: map['reciterName'],
      url: map['url'],
    );
  }
}
