import 'dart:convert';

import 'package:azkar_app/cubit/azkar_cubit/azkar_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../model/azkar_model/azkar_model/azkar_model.dart';

class AzkarCubit extends Cubit<AzkarState> {
  AzkarCubit() : super(AzkarInitial());
  void loadAzkar() async {
    emit(AzkarLoading());
    try {
      final String jsonContent =
          await rootBundle.loadString('assets/db/adhkar.json');
      ; // استبدل بمحتوى JSON الفعلي
      final jsonData = jsonDecode(jsonContent) as List;
      final azkar = jsonData.map((json) => AzkarModel.fromJson(json)).toList();
      emit(AzkarLoaded(azkar));
    } catch (e) {
      emit(AzkarError(e.toString()));
    }
  }
}
