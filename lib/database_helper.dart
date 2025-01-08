import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:azkar_app/constants.dart';
import 'package:azkar_app/model/fav_dars_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/quran_models/fav_model.dart';
import 'model/book_mark_model.dart';
import 'model/praying_model/praying_model/timings.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  static const columnId = 'id';
  static const columnCategory = 'category';
  static const columnZekerList = 'ZekerList';

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'favorites.db');
    // await deleteDatabase(path);

    // Create a new database
    return await openDatabase(
      path,
      version: 3, // Ensure this matches your new schema version
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE favorites(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          surahIndex INTEGER,
          reciterName TEXT,
          reciterUrl TEXT,
          zeroPaddingSurahNumber INTEGER,
          url TEXT
        )
      ''');
        await db.execute('''
       CREATE TABLE bookmarks(  
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          surahName TEXT,
          pageNumber INTEGER
        )

      ''');
        await db.execute('''
      CREATE TABLE favDars(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          url TEXT
        )
      ''');
        await db.execute('''
      CREATE TABLE fontSize(
          fontSize DOUBLE
        )
      ''');
        await db.execute(
          'CREATE TABLE theme (id INTEGER PRIMARY KEY, themeMode TEXT)',
        );
        await db.execute('''
        CREATE TABLE favAzkarPage (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnCategory TEXT NOT NULL,
          $columnZekerList TEXT NOT NULL
        )
      ''');
        await db.execute('''
            CREATE TABLE timings (
              id INTEGER PRIMARY KEY,
              fajr TEXT,
              sunrise TEXT,
              dhuhr TEXT,
              asr TEXT,
              maghrib TEXT,
              isha TEXT,
              storedAt TEXT

            )
          ''');
      },
    );
  }

  Future<void> insertFavorite(FavModel fav) async {
    final db = await database;
    await db.insert(
      'favorites',
      fav.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FavModel>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return List.generate(maps.length, (i) {
      return FavModel.fromMap(maps[i]);
    });
  }

  Future<void> deleteFavorite(int surahIndex, String reciterName) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'surahIndex = ? AND reciterName = ?',
      whereArgs: [surahIndex, reciterName],
    );
  }

  Future<bool> isFavoriteExists(int surahIndex, String reciterName) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'favorites',
      where: 'surahIndex = ? AND reciterName = ?',
      whereArgs: [surahIndex, reciterName],
    );
    return result.isNotEmpty;
  }

  // Insert Bookmark
  Future<void> insertBookmark(BookMarkModel bookmark) async {
    final db = await database;
    await db.insert(
      'bookmarks',
      bookmark.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch All Bookmarks
  Future<List<BookMarkModel>> getBookmarks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bookmarks');
    return List.generate(maps.length, (i) {
      return BookMarkModel.fromMap(maps[i]);
    });
  }

  // Delete Bookmark
  Future<void> deleteBookmark(int? id) async {
    final db = await database;

    // Check if the ID is null
    if (id == null) {
      throw ArgumentError("Cannot delete a bookmark without an ID.");
    }

    // Proceed with deletion
    await db.delete(
      'bookmarks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertFavDars(FavDarsModel favDars) async {
    final db = await database;
    await db.insert(
      'favDars',
      favDars.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FavDarsModel>> getFavsDars() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favDars');
    return List.generate(maps.length, (i) {
      return FavDarsModel.fromMap(maps[i]);
    });
  }

  Future<void> deleteFavDars(int? id) async {
    final db = await database;

    // Check if the ID is null
    if (id == null) {
      throw ArgumentError("Cannot delete a bookmark without an ID.");
    }

    // Proceed with deletion
    await db.delete(
      'favDars',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
// Save font size to database
Future<void> changeFontSize(double fontSize) async {
  final db = await database;

  // Check if a font size already exists
  final result = await db.query('fontSize');

  if (result.isNotEmpty) {
    // Update existing font size
    await db.update(
      'fontSize',
      {'fontSize': fontSize},
      where: '1', // Always update the single entry
    );
  } else {
    // Insert a new font size if it doesn't exist
    await db.insert('fontSize', {'fontSize': fontSize});
  }
}

// Retrieve font size from database
Future<double> getFontSize() async {
  final db = await database;

  final List<Map<String, dynamic>> result = await db.query('fontSize');

  if (result.isNotEmpty) {
    return result.first['fontSize'] as double;
  } else {
    // Return default font size if no value exists
    return 35.0;
  }
}

  Future<void> saveTheme(String themeMode) async {
    final db = await database;
    await db.insert(
      'theme',
      {'id': 1, 'themeMode': themeMode},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> fetchTheme() async {
    final db = await database;
    final result = await db.query('theme', where: 'id = ?', whereArgs: [1]);
    if (result.isNotEmpty) {
      return result.first['themeMode'] as String;
    }
    return defaultTheme;
  }

  Future<void> insertFavAzkar(String category, List zekerList) async {
    final db = await database;
    await db.insert('favAzkarPage', {
      columnCategory: category,
      columnZekerList: jsonEncode(zekerList), // Convert list to JSON string
    });
  }

  Future<void> deleteFavAzkar(String category) async {
    final db = await database;
    await db.delete('favAzkarPage',
        where: '$columnCategory = ?', whereArgs: [category]);
  }

  Future<bool> isFavZekrExit(String category) async {
    final db = await database;
    final result = await db.query(
      'favAzkarPage',
      where: '$columnCategory = ?',
      whereArgs: [category],
    );
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getFavsAzkar() async {
    final db = await database;
    final results = await db.query('favAzkarPage');

    return results.map((record) {
      return {
        'category':
            record[columnCategory] as String, // Ensure category is a String
        'zekerList':
            jsonDecode(record[columnZekerList] as String), // Cast to String
      };
    }).toList();
  }

  Future<void> insertTimings(Timings timings) async {
    final db = await database;
    try {
      await db.insert(
        'timings',
        {
          'fajr': timings.fajr,
          'sunrise': timings.sunrise,
          'dhuhr': timings.dhuhr,
          'asr': timings.asr,
          'maghrib': timings.maghrib,
          'isha': timings.isha,
          'storedAt': DateFormat('dd-MM-yyyy').format(DateTime.now()),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<Map<String, String>?> getTimings() async {
    final db = await database;
    final result = await db.query('timings', orderBy: 'id DESC', limit: 1);
    if (result.isNotEmpty) {
      final data = result.first;
      return {
        'fajr': data['fajr'] as String,
        'sunrise': data['sunrise'] as String,
        'dhuhr': data['dhuhr'] as String,
        'asr': data['asr'] as String,
        'maghrib': data['maghrib'] as String,
        'isha': data['isha'] as String,
        'storedAt': data['storedAt'] as String,
      };
    }
    return null;
  }
}
