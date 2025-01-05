import 'package:flutter/material.dart';
import '../cubit/praying_cubit/praying_cubit.dart';
import 'prayer_times_widget.dart';

Widget buildPrayerDetails(
    BuildContext context, PrayingLoaded state, scrollController) {
  return Column(
    children: [
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
                  "صلاة ${state.nextPrayerName}",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xff6a564f),
                  ),
                ),
                Text(
                  "${state.nextPraying}",
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
      Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: buildPrayerTimes(context, state),
          ),
        ),
      ),
    ],
  );
}
