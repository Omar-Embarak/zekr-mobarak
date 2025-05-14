part of 'fav_surah_item_cubit.dart';

abstract class FavSurahItemState extends Equatable {
  const FavSurahItemState();

  @override
  List<Object> get props => [];
}

class FavSurahItemInitial extends FavSurahItemState {}

class FavSurahItemLoading extends FavSurahItemState {}

class FavSurahItemSuccess extends FavSurahItemState {}

class FavSurahItemFailure extends FavSurahItemState {
  final String errorMessage;

  const FavSurahItemFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
