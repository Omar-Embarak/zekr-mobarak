import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../database_helper.dart';
import '../../model/quran_models/fav_model.dart';

part 'add_fav_surah_item_state.dart';

class AddFavSurahItemCubit extends Cubit<AddFavSurahItemState> {
  final FavSurahDatabaseHelper dbHelper = FavSurahDatabaseHelper();

  AddFavSurahItemCubit() : super(AddFavSurahItemInitial());

  // Add favorite surah to SQLite
  Future<void> addFavSurahItem(FavModel favSurahItem) async {
    try {
      emit(AddFavSurahItemLoading());
      await dbHelper.insertFavSurah(favSurahItem);
      final favSurahs = await dbHelper.getFavSurahs();
      emit(AddFavSurahItemSuccess(favSurahs: favSurahs));
    } catch (e) {
      emit(AddFavSurahItemFailure(e.toString()));
    }
  }

  // Fetch favorite surahs
  Future<void> fetchFavSurahs() async {
    try {
      emit(AddFavSurahItemLoading());
      final favSurahs = await dbHelper.getFavSurahs();
      emit(AddFavSurahItemSuccess(favSurahs: favSurahs));
    } catch (e) {
      emit(AddFavSurahItemFailure(e.toString()));
    }
  }

  // Delete favorite surah
  Future<void> deleteFavSurah(int id) async {
    try {
      emit(AddFavSurahItemLoading());
      await dbHelper.deleteFavSurah(id);
      final favSurahs = await dbHelper.getFavSurahs();
      emit(AddFavSurahItemSuccess(favSurahs: favSurahs));
    } catch (e) {
      emit(AddFavSurahItemFailure(e.toString()));
    }
  }
}
