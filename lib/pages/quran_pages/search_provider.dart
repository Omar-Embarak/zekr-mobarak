import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  String _query = '';

  String get query => _query;

  void updateQuery(String newQuery) {
    _query = newQuery;
    notifyListeners();
  }
}
