part of 'ruqiya_cubit.dart';

abstract class RuqiyaState {}

final class RuqiyaInitial extends RuqiyaState {}

final class RuqiyaLoading extends RuqiyaState {}

final class RuqiyaLoaded extends RuqiyaState {
  final List<RuqiyaModel> ruqiya;

  RuqiyaLoaded(this.ruqiya);
}

final class RuqiyaError extends RuqiyaState {
  final String error;

  RuqiyaError(this.error);
}
