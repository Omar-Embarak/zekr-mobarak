import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../database_helper.dart';

part 'fav_zekr_state.dart';

class FavZekrCubit extends Cubit<FavZekrState> {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  FavZekrCubit() : super(FavZekrInitial());

  Future<void> toggleFavorite(String category, List zekerList) async {
    final isFavorite = await databaseHelper.isFavZekrExit(category);
    if (isFavorite) {
      await databaseHelper.deleteFavAzkar(category);
    } else {
      await databaseHelper.insertFavAzkar(category, zekerList);
    }
    fetchFavorites(); // Refresh the favorites list to trigger the UI update
  }

  Future<void> fetchFavorites() async {
    emit(FavZekrLoading());
    try {
      final favorites = await databaseHelper.getFavsAzkar();
      emit(FavZekrLoaded(favorites));
    } catch (e) {
      emit(FavZekrError("Error loading favorites"));
    }
  }
}
