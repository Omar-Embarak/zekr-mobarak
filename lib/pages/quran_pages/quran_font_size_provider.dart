import 'package:flutter/material.dart';

import '../../database_helper.dart';

class QuranFontSizeProvider with ChangeNotifier {
  double _fontSize = 35;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  double get fontSize => _fontSize;

  set fontSize(double newSize) {
    _fontSize = newSize;
   _dbHelper.changeFontSize(newSize);

    notifyListeners(); 
  }

  Future<void> _loadFontSize() async {
    _fontSize = await _dbHelper.getFontSize(); // Load the font size from the database
    notifyListeners();
  }
}
