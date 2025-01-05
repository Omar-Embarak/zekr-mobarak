import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import '../cubit/praying_cubit/praying_cubit.dart';

List<Widget> buildPrayerTimes(BuildContext context, PrayingLoaded state) {
  final prayerTimes = [
    {"name": "الفجر", "time": state.timings.fajr},
    {"name": "الشروق", "time": state.timings.sunrise},
    {"name": "الظهر", "time": state.timings.dhuhr},
    {"name": "العصر", "time": state.timings.asr},
    {"name": "المغرب", "time": state.timings.maghrib},
    {"name": "العشاء", "time": state.timings.isha},
  ];

  return prayerTimes
      .map(
        (prayer) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                prayer["name"]!,
                style: AppStyles.styleCairoBold20(context),
              ),
              Text(
                prayer["time"]!,
                style: AppStyles.styleCairoBold20(context),
              ),
            ],
          ),
        ),
      )
      .toList();
}
