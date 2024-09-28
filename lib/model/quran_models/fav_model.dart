import 'package:hive/hive.dart';
part 'fav_model.g.dart';
@HiveType(typeId: 0)
class FavModel extends HiveObject {
  @HiveField(0)
  String surahName;
  @HiveField(1)
  String reciterName;
  @HiveField(2)
  String url;
  FavModel({
    required this.url,
    required this.reciterName,
    required this.surahName,
  });
}
