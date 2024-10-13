part of 'add_fav_surah_item_cubit.dart';

abstract class AddFavSurahItemState extends Equatable {
  const AddFavSurahItemState();

  @override
  List<Object> get props => [];
}

class AddFavSurahItemInitial extends AddFavSurahItemState {}

class AddFavSurahItemLoading extends AddFavSurahItemState {}

class AddFavSurahItemSuccess extends AddFavSurahItemState {}

class AddFavSurahItemFailure extends AddFavSurahItemState {
  final String errorMessage;

  const AddFavSurahItemFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
