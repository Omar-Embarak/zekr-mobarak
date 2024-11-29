part of 'praying_cubit.dart';

abstract class PrayingState {}

class PrayingInitial extends PrayingState {}

class PrayingLoading extends PrayingState {}

class PrayingLoaded extends PrayingState {
  final PrayingModel prayerTimes;

  final Timings timings;

  final String nextPraying;
  final String nextPrayerName;
  PrayingLoaded(
      this.prayerTimes, this.nextPraying, this.nextPrayerName, this.timings);
}

class PrayingError extends PrayingState {
  final String error;

  PrayingError(this.error);
}
