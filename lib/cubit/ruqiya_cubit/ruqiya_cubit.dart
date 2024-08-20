import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import '../../model/ruqiya_model/ruqiya_model/ruqiya_model.dart';
part 'ruqiya_state.dart';

class RuqiyaCubit extends Cubit<RuqiyaState> {
  RuqiyaCubit() : super(RuqiyaInitial());

  void loadRuqiya() async {
    emit(RuqiyaLoading());

    try {
      final String jsonContent =
          await rootBundle.loadString("assets/db/ruqiya.json");

      final jsonData = jsonDecode(jsonContent) as List;

      final ruqiya =
          jsonData.map((doaa) => RuqiyaModel.fromJson(doaa)).toList();

      emit(RuqiyaLoaded(ruqiya));
    } catch (e) {
      emit(RuqiyaError(e.toString()));
    }
  }
}
