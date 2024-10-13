import 'reciters_model.dart';

class FavModel {
  final int surahIndex;
  final RecitersModel reciter;
  final String url;

  FavModel({
    required this.surahIndex,
    required this.reciter,
    required this.url,
  });

  // Map model to SQLite table columns
  Map<String, dynamic> toMap() {
    return {
      'surahIndex': surahIndex,
      'reciterName': reciter.name,
      'reciterUrl': reciter.url,
      'zeroPaddingSurahNumber': reciter.zeroPaddingSurahNumber ? 1 : 0, // Convert bool to int for SQLite
      'url': url,
    };
  }

  static FavModel fromMap(Map<String, dynamic> map) {
    return FavModel(
      surahIndex: map['surahIndex'],
      reciter: RecitersModel(
        name: map['reciterName'],
        url: map['reciterUrl'],
        zeroPaddingSurahNumber: map['zeroPaddingSurahNumber'] == 1, // Convert int back to bool
      ),
      url: map['url'],
    );
  }
}
