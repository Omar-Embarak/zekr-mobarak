import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../database_helper.dart';
import '../../model/praying_model/praying_model/praying_model.dart';
import '../../model/praying_model/praying_model/timings.dart';
import '../../pages/azkar_pages/notification_service.dart';

part 'praying_state.dart';

class PrayingCubit extends Cubit<PrayingState> {
  PrayingCubit() : super(PrayingInitial());
  final List<String> prayerNames = [
    "الفجر",
    "الشروق",
    "الظهر",
    "العصر",
    "المغرب",
    "العشاء"
  ];

  String? nextPrayerTitle;
  Future<void> getPrayerTimesByAddress({
    required int day,
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
        var nextPrayer = calculateTimeUntilNextPrayer(
            prayerTimesData.data![day - 1].timings!);

        NotificationService.isNotificationsEnabled()
            ? NotificationService.schedulePrayerNotifications(
                prayerTimesData.data![day - 1].timings!)
            : null;

        Timings convertTimingsTo12HourFormat(Timings timings) {
          return Timings(
            fajr: convertTo12HourFormat(timings.fajr!),
            sunrise: convertTo12HourFormat(timings.sunrise!),
            dhuhr: convertTo12HourFormat(timings.dhuhr!),
            asr: convertTo12HourFormat(timings.asr!),
            maghrib: convertTo12HourFormat(timings.maghrib!),
            isha: convertTo12HourFormat(timings.isha!),
          );
        }

        final timings = convertTimingsTo12HourFormat(
            prayerTimesData.data![day - 1].timings!);
        final db = DatabaseHelper();
        await db.insertTimings(timings);

        emit(PrayingLoaded(
          prayerTimesData,
          nextPrayer,
          nextPrayerTitle!,
          convertTimingsTo12HourFormat(prayerTimesData.data![day - 1].timings!),
        ));
      }
    } catch (e) {
      emit(PrayingError(e.toString()));
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
      timings.sunrise,
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
          prayerTime = prayerTime.add(const Duration(days: 1));
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
