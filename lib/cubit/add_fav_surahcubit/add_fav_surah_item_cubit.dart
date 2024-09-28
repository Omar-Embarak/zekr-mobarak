import 'package:azkar_app/constants.dart';
import 'package:azkar_app/model/quran_models/fav_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'add_fav_surah_item_state.dart';

class AddFavSurahItemCubit extends Cubit<AddFavSurahItemState> {
  AddFavSurahItemCubit() : super(AddFavSurahItemInitial());
  addFavSurahItem(FavModel favSurahItem) async {
    try {
      emit(AddFavSurahItemLoading());
      var favSurahBox = Hive.box<FavModel>(kFavSurahBox);
      await favSurahBox.add(favSurahItem);
      emit(AddFavSurahItemSuccess());
    }   catch (e) {
      emit(AddFavSurahItemFailure(e.toString()));
    }
  }
}
