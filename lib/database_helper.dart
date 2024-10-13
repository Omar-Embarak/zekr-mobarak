import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/quran_models/fav_model.dart';

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
    return await openDatabase(
      path,
      version: 3, // Update the version number
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            surahIndex INTEGER,
            reciterName TEXT,
            reciterUrl TEXT,
            zeroPaddingSurahNumber INTEGER,
            url TEXT
          )
          '''
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute('ALTER TABLE favorites ADD COLUMN zeroPaddingSurahNumber INTEGER');
        }
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
}
