import 'dart:convert';

import 'package:bloc/bloc.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../model/praying_model/praying_model/praying_model.dart';
import '../../model/praying_model/praying_model/timings.dart';

part 'praying_state.dart';

class PrayingCubit extends Cubit<PrayingState> {
  PrayingCubit() : super(PrayingInitial());
  final List<String> prayerNames = [
    "الفجر",
    "الظهر",
    "العصر",
    "المغرب",
    "العشاء"
  ];

  String? nextPrayerTitle;
  Future<void> getPrayerTimesByAddress({
    required String year,
    required String month,
    required double latitude,
    required double longitude,
  }) async {
    emit(PrayingLoading());
    try {
      final response = await http.get(Uri.parse(
          'http://api.aladhan.com/v1/calendar/$year/$month?latitude=$latitude&longitude=$longitude&method=5'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final prayerTimesData = PrayingModel.fromJson(jsonResponse);
        var nextPrayer =
            calculateTimeUntilNextPrayer(prayerTimesData.data![0].timings!);

        print(nextPrayer);
        Timings convertTimingsTo12HourFormat(Timings timings) {
          return Timings(
            fajr: convertTo12HourFormat(timings.fajr!),
            dhuhr: convertTo12HourFormat(timings.dhuhr!),
            asr: convertTo12HourFormat(timings.asr!),
            maghrib: convertTo12HourFormat(timings.maghrib!),
            isha: convertTo12HourFormat(timings.isha!),
            // قم بتحويل الأوقات الأخرى بنفس الطريقة إذا لزم الأمر
          );
        }

        emit(PrayingLoaded(
          prayerTimesData,
          nextPrayer,
          nextPrayerTitle!,
          convertTimingsTo12HourFormat(prayerTimesData.data![0].timings!),
        ));
      }
    } catch (e) {
      emit(PrayingEError(e.toString()));
    }
  }

//----------------
  String convertTo12HourFormat(String time24Hour) {
    // إزالة (EET) من الوقت
    String timeWithoutEET = time24Hour.split(" ")[0];

    // تحليل الوقت باستخدام تنسيق 24 ساعة
    DateFormat inputFormat = DateFormat("HH:mm");
    DateTime dateTime = inputFormat.parse(timeWithoutEET);

    // تحويل الوقت إلى تنسيق 12 ساعة
    DateFormat outputFormat = DateFormat("hh:mm a");
    String time12Hour = outputFormat.format(dateTime);

    return time12Hour;
  }

  //---------------
  String calculateTimeUntilNextPrayer(Timings timings) {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat("HH:mm");

    List<String?> prayerTimes = [
      timings.fajr,
      timings.dhuhr,
      timings.asr,
      timings.maghrib,
      timings.isha,
    ];

    DateTime? nextPrayerTime;
    Duration? smallestDifference;
    String? nextPrayerName; // لحفظ اسم الصلاة القادمة

    for (int i = 0; i < prayerTimes.length; i++) {
      String? timeString = prayerTimes[i];
      if (timeString != null) {
        DateTime prayerTime = DateTime(
            now.year,
            now.month,
            now.day,
            format.parse(timeString.split(" ")[0]).hour,
            format.parse(timeString.split(" ")[0]).minute);

        if (prayerTime.isBefore(now)) {
          prayerTime = prayerTime.add(Duration(days: 1));
        }

        Duration difference = prayerTime.difference(now);

        if (smallestDifference == null || difference < smallestDifference) {
          smallestDifference = difference;
          nextPrayerTime = prayerTime;
          nextPrayerName = prayerNames[i]; // تحديث اسم الصلاة القادمة
        }
      }
    }

    if (nextPrayerTime != null &&
        smallestDifference != null &&
        nextPrayerName != null) {
      int hours = smallestDifference.inHours;
      int minutes = smallestDifference.inMinutes.remainder(60);
      int seconds = smallestDifference.inSeconds.remainder(60);
      nextPrayerTitle = nextPrayerName;
      String formattedTime =
          "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
      return formattedTime;
    } else {
      return "لم يتم العثور على وقت الصلاة";
    }
  }
}
