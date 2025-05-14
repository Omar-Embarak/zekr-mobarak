import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../database_helper.dart';
import '../../methods.dart';
import '../../model/quran_models/fav_model.dart';

part 'fav_surah_item_state.dart';

class FavSurahItemCubit extends Cubit<FavSurahItemState> {
  FavSurahItemCubit() : super(FavSurahItemInitial());
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> addFavSurahItem(FavModel favSurahItem) async {
    try {
      emit(FavSurahItemLoading());
      _databaseHelper.insertFavorite(favSurahItem);
      emit(FavSurahItemSuccess());
      showMessage('تمت اضافة السورة الي المفضلة');
    } catch (e) {
      emit(FavSurahItemFailure(e.toString()));
      showMessage('حدث خطأ ما اثناء اضافة السورة الي المفضلة: ${e.toString()}');
    }
  }

  Future<void> deleteFavSurah(int surahIndex, String reciterName) async {
    try {
      emit(FavSurahItemLoading());
      _databaseHelper.deleteFavorite(surahIndex, reciterName);
      emit(FavSurahItemSuccess());
      showMessage('تمت ازالة السورة من المفضلة');
    } catch (e) {
      emit(FavSurahItemFailure(e.toString()));
      showMessage('حدث خطأ مااثناء ازالة السورة من المفضلة: ${e.toString()}');
    }
  }
}
