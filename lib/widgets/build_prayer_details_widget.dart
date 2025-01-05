import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/praying_model/praying_model/timings.dart';
import 'prayer_times_widget.dart';

Widget buildPrayerDetails(
    BuildContext context, Timings timings, ScrollController scrollController) {
  // Helper function to calculate the next prayer
  Map<String, String> calculateNextPrayer(Timings timings) {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat("hh:mm a");

    final prayerTimes = {
      "الفجر": timings.fajr,
      "الشروق": timings.sunrise,
      "الظهر": timings.dhuhr,
      "العصر": timings.asr,
      "المغرب": timings.maghrib,
      "العشاء": timings.isha,
    };

    DateTime? nextPrayerTime;
    String? nextPrayerName;

    for (var entry in prayerTimes.entries) {
      if (entry.value != null) {
        final parsedTime = format.parse(entry.value!);
        final prayerDateTime = DateTime(
            now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);

        if (prayerDateTime.isAfter(now)) {
          if (nextPrayerTime == null ||
              prayerDateTime.isBefore(nextPrayerTime)) {
            nextPrayerTime = prayerDateTime;
            nextPrayerName = entry.key;
          }
        }
      }
    }

    // Handle transition to the next day's Fajr if no prayers are left today
    if (nextPrayerTime == null) {
      final fajrTime = prayerTimes["الفجر"];
      if (fajrTime != null) {
        final parsedFajrTime = format.parse(fajrTime);
        nextPrayerTime = DateTime(
          now.year,
          now.month,
          now.day + 1,
          parsedFajrTime.hour,
          parsedFajrTime.minute,
        );
        nextPrayerName = "الفجر";
      }
    }

    if (nextPrayerTime != null && nextPrayerName != null) {
      final remainingTime = nextPrayerTime.difference(now);
      final hours = remainingTime.inHours.toString().padLeft(2, '0');
      final minutes =
          remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');

      return {"name": nextPrayerName, "time": "$hours:$minutes"};
    }

    return {"name": "لا توجد صلاة قادمة", "time": "00:00"};
  }

  final nextPrayer = calculateNextPrayer(timings);

  return Column(
    children: [
      // Next prayer details card
      Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.12,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Image.asset(
              "assets/images/next_prayer.png",
              height: 50,
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${nextPrayer['name']}",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xff6a564f),
                  ),
                ),
                Text(
                  "متبقي ${nextPrayer['time']}",
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color(0xff6a564f),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
      // Horizontal prayer times scrollable row
      Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: buildPrayerTimes(context, timings),
          ),
        ),
      ),
    ],
  );
}
