import 'dart:convert';
import 'package:flutter/services.dart';

import '../model/quran_models/juz_model.dart';

Future<Juz> loadJuzData(String path) async {
  String jsonString = await rootBundle.loadString(path);
  final jsonResponse = json.decode(jsonString);
  return Juz.fromJson(jsonResponse[0]);
}
