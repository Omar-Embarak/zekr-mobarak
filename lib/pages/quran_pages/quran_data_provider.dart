import 'package:flutter/material.dart';

class QuranDataProvider extends ChangeNotifier {
  List<dynamic> juzData = [];

  void setJuzData(List<dynamic> data) {
    juzData = data;
    notifyListeners();
  }

  List<dynamic> get getJuzData => juzData;
}
