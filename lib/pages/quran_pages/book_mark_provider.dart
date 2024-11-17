import 'package:flutter/material.dart';

import '../../model/book_mark_model.dart';

class BookmarkProvider with ChangeNotifier {
  List<BookMarkModel> _bookmarks = [
    BookMarkModel('الفاتحة', 1),
    BookMarkModel('البقرة', 2),
    BookMarkModel('آل عمران', 3), // Add more items
  ];

  List<BookMarkModel> get bookmarks => _bookmarks;

  void addBookmark(BookMarkModel bookmark) {
    _bookmarks.add(bookmark);
    notifyListeners();
  }

  void removeBookmark(int index) {
    _bookmarks.removeAt(index);
    notifyListeners();
  }
}
