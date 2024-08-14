import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkProvider extends ChangeNotifier {
  List<String> _bookmarks = [];

  List<String> get bookmarks => _bookmarks;

  void addBookmark(String bookmark) {
    if (!_bookmarks.contains(bookmark)) {
      _bookmarks.add(bookmark);
      notifyListeners();
    }
  }

  void removeBookmark(String bookmark) {
    if (_bookmarks.contains(bookmark)) {
      _bookmarks.remove(bookmark);
      notifyListeners();
    }
  }

  Future<void> loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _bookmarks = prefs.getStringList('bookmarks') ?? [];
    notifyListeners();
  }

  Future<void> saveBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookmarks', _bookmarks);
  }
}
