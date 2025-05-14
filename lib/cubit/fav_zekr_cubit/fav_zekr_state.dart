part of 'fav_zekr_cubit.dart';

abstract class FavZekrState extends Equatable {
  const FavZekrState();

  @override
  List<Object> get props => [];
}

class FavZekrInitial extends FavZekrState {}

class FavZekrLoading extends FavZekrState {}

class FavZekrLoaded extends FavZekrState {
  final List<Map<String, dynamic>> favorites;
  const FavZekrLoaded(this.favorites);
  @override
  List<Object> get props => [favorites];
}

class FavZekrError extends FavZekrState {
  final String message;
  const FavZekrError(this.message);
  @override
  List<Object> get props => [message];
}

class FavZekrUpdated extends FavZekrState {} //New State