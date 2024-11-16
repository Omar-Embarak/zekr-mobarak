import 'package:flutter/material.dart';
class BookmarkProvider with ChangeNotifier {
  List<String> _bookmarks = [];

  List<String> get bookmarks => _bookmarks;

  void addBookmark(String bookmark) {
    _bookmarks.add(bookmark);
    notifyListeners();
  }

  void removeBookmark(int index) {
    _bookmarks.removeAt(index);
    notifyListeners();
  }
}
