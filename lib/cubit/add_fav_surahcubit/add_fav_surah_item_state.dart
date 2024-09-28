part of 'add_fav_surah_item_cubit.dart';

sealed class AddFavSurahItemState extends Equatable {
  const AddFavSurahItemState();

  @override
  List<Object> get props => [];
}

final class AddFavSurahItemInitial extends AddFavSurahItemState {}

final class AddFavSurahItemLoading extends AddFavSurahItemState {}

final class AddFavSurahItemSuccess extends AddFavSurahItemState {}

final class AddFavSurahItemFailure extends AddFavSurahItemState {
  final String errMessage;

  const AddFavSurahItemFailure(this.errMessage);
}
