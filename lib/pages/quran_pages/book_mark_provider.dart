import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../database_helper.dart';
import '../../model/book_mark_model.dart';

class BookmarkProvider with ChangeNotifier {
  List<BookMarkModel> _bookmarks = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<BookMarkModel> get bookmarks => _bookmarks;

  BookmarkProvider() {
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    _bookmarks = await _dbHelper.getBookmarks();
    notifyListeners();
  }

Future<void> addBookmark(BookMarkModel bookmark) async {
  final db = await _dbHelper.database;

  // Insert and retrieve the auto-generated ID
  int id = await db.insert(
    'bookmarks',
    bookmark.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  // Add the bookmark with the generated ID
  final newBookmark = BookMarkModel(
    id: id,
    surahName: bookmark.surahName,
    pageNumber: bookmark.pageNumber,
  );

  _bookmarks.add(newBookmark);
  notifyListeners();
}


 Future<void> removeBookmark(int index) async {
  final bookmark = _bookmarks[index];

  // Validate ID
  if (bookmark.id == null) {
    print("Cannot delete bookmark. ID is null.");
    return;
  }

  await _dbHelper.deleteBookmark(bookmark.id);
  _bookmarks.removeAt(index);
  notifyListeners();
}

}
