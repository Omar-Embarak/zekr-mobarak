import 'dart:convert';
import 'package:azkar_app/cubit/azkar_cubit/azkar_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../model/azkar_model/azkar_model/azkar_model.dart';
  import 'package:shared_preferences/shared_preferences.dart';

class AzkarCubit extends Cubit<AzkarState> {
  AzkarCubit(List<AzkarModel> preloadedAzkar) : super(AzkarLoaded(preloadedAzkar));

void _cacheAzkarData(String jsonContent) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('azkar_data', jsonContent);
}

Future<String?> _loadCachedAzkarData() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('azkar_data');
}

 void loadAzkar() async {
  emit(AzkarLoading());
  try {
    String? cachedData = await _loadCachedAzkarData();
    if (cachedData == null) {
      final String jsonContent = await rootBundle.loadString('assets/db/adhkar.json');
      _cacheAzkarData(jsonContent); // Cache the data
      cachedData = jsonContent;
    }

    final jsonData = jsonDecode(cachedData) as List;
    final azkar = jsonData.map((json) => AzkarModel.fromJson(json)).toList();
    emit(AzkarLoaded(azkar));
  } catch (e) {
    emit(AzkarError(e.toString()));
  }
}
}
