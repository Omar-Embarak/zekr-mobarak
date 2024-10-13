import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../database_helper.dart';
import '../../model/quran_models/fav_model.dart';

part 'add_fav_surah_item_state.dart';

class AddFavSurahItemCubit extends Cubit<AddFavSurahItemState> {
  AddFavSurahItemCubit() : super(AddFavSurahItemInitial());
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> addFavSurahItem(FavModel favSurahItem) async {
    try {
      emit(AddFavSurahItemLoading());
      _databaseHelper.insertFavorite(favSurahItem);
      emit(AddFavSurahItemSuccess());
    } catch (e) {
      emit(AddFavSurahItemFailure(e.toString()));
    }
  }

  Future<void> deleteFavSurah(int surahIndex, String reciterName) async {
    try {
      emit(AddFavSurahItemLoading());
      _databaseHelper.deleteFavorite( surahIndex,reciterName);
      emit(AddFavSurahItemSuccess());
    } catch (e) {
      emit(AddFavSurahItemFailure(e.toString()));
    }
  }
}
