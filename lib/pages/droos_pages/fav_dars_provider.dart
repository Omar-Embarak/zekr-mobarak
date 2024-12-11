import 'package:azkar_app/methods.dart';
import 'package:azkar_app/model/fav_dars_model.dart';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../database_helper.dart';

class FavDarsProvider with ChangeNotifier {
  List<FavDarsModel> _favsDars = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<FavDarsModel> get favsDars => _favsDars;

  FavDarsProvider() {
    loadFavsDars();
  }

  Future<void> loadFavsDars() async {
    _favsDars = await _dbHelper.getFavsDars();
    notifyListeners();
  }

  Future<void> addFavDars(FavDarsModel favDars) async {
    final db = await _dbHelper.database;

    // Insert and retrieve the auto-generated ID
    int id = await db.insert(
      'favDars',
      favDars.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Add the FavDars with the generated ID
    final newFavDars = FavDarsModel(
      id: id,
      name: favDars.name,
      url: favDars.url,
    );

    _favsDars.add(newFavDars);
    notifyListeners();
  }

  Future<void> removeFavDars(int index) async {
    final favDars = _favsDars[index];

    // Validate ID
    if (favDars.id == null) {
      showMessage("Cannot delete this dars. ID is null.");
      return;
    }

    await _dbHelper.deleteFavDars(favDars.id);
    _favsDars.removeAt(index);
    notifyListeners();
  }
}
