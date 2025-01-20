import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/material.dart';

class AppColors {
  static Color get kPrimaryColor {
    final themeMode = AppStyles.themeNotifier
        .value; // Assuming themeNotifier is correctly initialized and accessible
    if (themeMode == defaultTheme) {
      return const Color(0xffcfad65);
    } else if (themeMode == lightTheme) {
      return Colors.white; // Use predefined white color
    } else {
      return const Color(0xff0f0f0f); // Correct way to define a custom color
    }
  }

  static Color get kSecondaryColor {
    final themeMode = AppStyles.themeNotifier
        .value; // Assuming themeNotifier is correctly initialized and accessible
    if (themeMode == defaultTheme) {
      return const Color(0xff6a564f);
    } else if (themeMode == lightTheme) {
      return const Color.fromARGB(
          255, 227, 227, 227); // Use predefined white color
    } else {
      return const Color(0xff0f0f0f); // Correct way to define a custom color
    }
  }
}

const String darkTheme = "Dark";
const String lightTheme = "light";
const String defaultTheme = "default";
// Arabic ordinals for the Juz
const List<String> arabicOrdinals = [
  'الاول',
  'الثاني',
  'الثالث',
  'الرابع',
  'الخامس',
  'السادس',
  'السابع',
  'الثامن',
  'التاسع',
  'العاشر',
  'الحادي عشر',
  'الثاني عشر',
  'الثالث عشر',
  'الرابع عشر',
  'الخامس عشر',
  'السادس عشر',
  'السابع عشر',
  'الثامن عشر',
  'التاسع عشر',
  'العشرون',
  'الحادي والعشرون',
  'الثاني والعشرون',
  'الثالث والعشرون',
  'الرابع والعشرون',
  'الخامس والعشرون',
  'السادس والعشرون',
  'السابع والعشرون',
  'الثامن والعشرون',
  'التاسع والعشرون',
  'الثلاثون',
];



