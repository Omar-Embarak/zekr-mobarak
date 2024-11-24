import 'package:al_quran/al_quran.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/material.dart';

WidgetSpan bamallaWidget(BuildContext context) {
  return WidgetSpan(
    alignment: PlaceholderAlignment.middle,
    child: Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 4.0), // Control space above and below
        child: Text(
          AlQuran.getBismillah.unicode, // Removed extra \n
          style: AppStyles.styleAmiriMedium30(context).copyWith(fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}
