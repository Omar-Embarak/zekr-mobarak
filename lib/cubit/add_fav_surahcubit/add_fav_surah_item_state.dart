part of 'add_fav_surah_item_cubit.dart';

sealed class AddFavSurahItemState extends Equatable {
  const AddFavSurahItemState();

  @override
  List<Object?> get props => [];
}

class AddFavSurahItemInitial extends AddFavSurahItemState {}

class AddFavSurahItemLoading extends AddFavSurahItemState {}

class AddFavSurahItemSuccess extends AddFavSurahItemState {
  final List<FavModel>? favSurahs;

  const AddFavSurahItemSuccess({required this.favSurahs});

  @override
  List<Object?> get props => [favSurahs];
}

class AddFavSurahItemFailure extends AddFavSurahItemState {
  final String errorMessage;

  const AddFavSurahItemFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
