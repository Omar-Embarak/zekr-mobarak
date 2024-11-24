import 'package:azkar_app/model/fav_dars_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/quran_models/fav_model.dart';
import 'model/book_mark_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

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
      version: 4, // Ensure this matches your new schema version
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
  } Future<List<FavDarsModel>> getFavsDars() async {
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
}
