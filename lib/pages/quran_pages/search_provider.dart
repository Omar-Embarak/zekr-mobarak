import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  String _query = '';

  String get query => _query;

  void updateQuery(String newQuery) {
    _query = newQuery;
    notifyListeners();
  }
}
// filter content of any open tab not only SurahListWidget, by the way the filter in SurahListWidget is by the value of "
//               'سورة ${quran.getSurahNameArabic(entry.key)}'," and in JuzListPage by the value of "                        "${getVerse(surahNumber, verseNumber).length > 30 ? getVerse(surahNumber, verseNumber).substring(0, 30) : getVerse(surahNumber, verseNumber)}...", "