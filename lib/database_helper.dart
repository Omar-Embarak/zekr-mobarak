import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../model/quran_models/fav_model.dart';

class FavSurahDatabaseHelper {
  static final FavSurahDatabaseHelper _instance = FavSurahDatabaseHelper.internal();
  factory FavSurahDatabaseHelper() => _instance;

  static Database? _db;

  FavSurahDatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), 'fav_surah.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            surahName TEXT,
            reciterName TEXT,
            url TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertFavSurah(FavModel favSurah) async {
    var dbClient = await db;
    return await dbClient.insert('favorites', favSurah.toMap());
  }

  Future<List<FavModel>> getFavSurahs() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('favorites');
    return List.generate(maps.length, (i) {
      return FavModel.fromMap(maps[i]);
    });
  }

  Future<int> deleteFavSurah(int id) async {
    var dbClient = await db;
    return await dbClient.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearFavSurahs() async {
    var dbClient = await db;
    await dbClient.delete('favorites');
  }
}
