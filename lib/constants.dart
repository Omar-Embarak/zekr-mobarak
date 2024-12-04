import 'package:flutter/material.dart';
class AppColors {
  static final ValueNotifier<String> themeNotifier = ValueNotifier<String>(defaultTheme);

  static Color get kPrimaryColor {
    final themeMode = themeNotifier.value;
    if (themeMode == defaultTheme) {
      return const Color(0xffcfad65);
    } else if (themeMode == lightTheme) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  static Color get kSecondaryColor {
    final themeMode = themeNotifier.value;
    if (themeMode == defaultTheme) {
      return const Color(0xff6a564f);
    } else if (themeMode == lightTheme) {
      return Colors.black;
    } else {
      return Colors.white;
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
