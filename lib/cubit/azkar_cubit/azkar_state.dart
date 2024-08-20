import 'package:azkar_app/model/azkar_model/azkar_model/azkar_model.dart';

abstract class AzkarState {}

class AzkarInitial extends AzkarState {}

class AzkarLoading extends AzkarState {}

class AzkarLoaded extends AzkarState {
  final List<AzkarModel> azkar;
  AzkarLoaded(this.azkar);
}

class AzkarError extends AzkarState {
  final String azkarError;
  AzkarError(this.azkarError);
}
