import 'package:flutter/material.dart';

class QuranFontSizeProvider with ChangeNotifier {
  double _fontSize = 35;

  double get fontSize => _fontSize;

  set fontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners(); 
  }
}
