// lib/cubit/surah_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../../model/quran_models/surah_model.dart';


class SurahCubit extends Cubit<List<Surah>> {
  SurahCubit() : super([]);

  void loadSurahs() async {
    final String response = await rootBundle.loadString('assets/quranjson/surah.json');
    final List<dynamic> data = jsonDecode(response);
    final surahs = data.map((json) => Surah.fromJson(json)).toList();
    emit(surahs);
  }
}
