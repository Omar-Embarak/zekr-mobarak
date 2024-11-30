import 'package:flutter/material.dart';
import '../cubit/praying_cubit/praying_cubit.dart';

List<Widget> buildPrayerTimes(PrayingLoaded state) {
    final prayerTimes = [
      {"name": "الفجر", "time": state.timings.fajr},
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
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  prayer["time"]!,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        )
        .toList();
  }
