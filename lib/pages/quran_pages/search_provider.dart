import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  String _query = '';
  bool _isSearching = false;
  String get query => _query;
  bool get isSearching => _isSearching;
  final TextEditingController _searchController = TextEditingController();

  void updateQuery(String newQuery) {
    _query = newQuery;
    notifyListeners();
  }

  // void clearSearchController() {
  //   _searchController.clear();
  //   notifyListeners();

  // }

   TextEditingController searchController() {
    return _searchController;
    
  }

  void toogleSearch(bool isSearching) {
    _isSearching = isSearching;
    notifyListeners();
  }
}
