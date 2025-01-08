import 'dart:async';
import 'package:flutter/material.dart';
import '../../database_helper.dart';

class QuranFontSizeProvider with ChangeNotifier {
  double _fontSize = 35; // Default font size
  final DatabaseHelper _dbHelper = DatabaseHelper();
  Timer? _debounce;

  double get fontSize => _fontSize;

  set fontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners();

    // Debounce the database update
    _debounce?.cancel(); // Cancel any previous timer
    _debounce = Timer(const Duration(milliseconds: 100), () {
      _dbHelper.changeFontSize(newSize); // Save to database after 300ms
    });
  }

  Future<void> loadFontSize() async {
    try {
      _fontSize =
          await _dbHelper.getFontSize(); // Load font size from the database
    } catch (e) {
      _fontSize = 35.0; // Default value in case of an error
    }
    notifyListeners(); // Notify widgets after loading
  }
}
