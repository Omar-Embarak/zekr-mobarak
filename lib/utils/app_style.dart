import 'package:flutter/material.dart';

import '../constants.dart';
import 'size_config.dart';

abstract class AppStyles {
  static final ValueNotifier<String> themeNotifier =
      ValueNotifier<String>(defaultTheme);

  static TextStyle styleCairoMedium15white(context) {
    return TextStyle(
      color: AppStyles.themeNotifier.value == defaultTheme
          ? Colors.white
          : (AppStyles.themeNotifier.value == lightTheme
              ? Colors.black
              : Colors.white),
      fontSize: getResponsiveFontSize(context, fontSize: 15),
      fontFamily: 'Cairo',
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleRajdhaniMedium20(context) {
    return TextStyle(
      color: AppStyles.themeNotifier.value == defaultTheme
          ? AppColors.kSecondaryColor
          : (AppStyles.themeNotifier.value == lightTheme
              ? Colors.black
              : Colors.white),
      fontSize: getResponsiveFontSize(context, fontSize: 20),
      fontFamily: 'Rajdhani',
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleRajdhaniMedium18(context) {
    return TextStyle(
      color: AppStyles.themeNotifier.value == defaultTheme
          ? const Color(0xff575757)
          : (AppStyles.themeNotifier.value == lightTheme
              ? Colors.black
              : Colors.white),
      fontSize: getResponsiveFontSize(context, fontSize: 18),
      fontFamily: 'Rajdhani',
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle alwaysBlack18(context) {
    return TextStyle(
      color: AppStyles.themeNotifier.value == defaultTheme
          ? const Color(0xff575757)
          : (AppStyles.themeNotifier.value == lightTheme
              ? Colors.black
              : Colors.black),
      fontSize: getResponsiveFontSize(context, fontSize: 18),
      fontFamily: 'Rajdhani',
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleRajdhaniMedium22(context) {
    return TextStyle(
      color: AppStyles.themeNotifier.value == defaultTheme
          ? const Color(0xff575757)
          : (AppStyles.themeNotifier.value == lightTheme
              ? Colors.black
              : Colors.white),
      fontSize: getResponsiveFontSize(context, fontSize: 22),
      fontFamily: 'Rajdhani',
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleRajdhaniBold20(context) {
    return TextStyle(
      color: AppStyles.themeNotifier.value == defaultTheme
          ? AppColors.kSecondaryColor
          : (AppStyles.themeNotifier.value == lightTheme
              ? Colors.black
              : Colors.white),
      fontSize: getResponsiveFontSize(context, fontSize: 20),
      fontFamily: 'Rajdhani',
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle styleRajdhaniBold13(context) {
    return TextStyle(
      color: AppStyles.themeNotifier.value == defaultTheme
          ? const Color(0xff575757)
          : (AppStyles.themeNotifier.value == lightTheme
              ? Colors.black
              : Colors.white),
      fontSize: getResponsiveFontSize(context, fontSize: 13),
      fontFamily: 'Rajdhani',
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle styleRajdhaniBold18(context) {
    return TextStyle(
      color: AppStyles.themeNotifier.value == defaultTheme
          ? const Color(0xff575757)
          : (AppStyles.themeNotifier.value == lightTheme
              ? Colors.black
              : Colors.white),
      fontSize: getResponsiveFontSize(context, fontSize: 18),
      fontFamily: 'Rajdhani',
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle styleRajdhaniBoldOrange20(context) {
    return TextStyle(
      color: AppStyles.themeNotifier.value == defaultTheme
          ? AppColors.kPrimaryColor
          : (AppStyles.themeNotifier.value == lightTheme
              ? Colors.black
              : Colors.white),
      fontSize: getResponsiveFontSize(context, fontSize: 20),
      fontFamily: 'Rajdhani',
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle styleRajdhaniMedium15(context) {
    return TextStyle(
      color: AppStyles.themeNotifier.value == defaultTheme
          ? const Color(0xff000000)
          : (AppStyles.themeNotifier.value == lightTheme
              ? Colors.black
              : Colors.white),
      fontSize: getResponsiveFontSize(context, fontSize: 15),
      fontFamily: 'Rajdhani',
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleDiodrumArabicMedium15(context) {
    return TextStyle(
      color: AppStyles.themeNotifier.value == defaultTheme
          ? const Color(0xffFFFFFF)
          : (AppStyles.themeNotifier.value == lightTheme
              ? Colors.black
              : Colors.white),
      fontSize: getResponsiveFontSize(context, fontSize: 15),
      fontFamily: 'DiodrumArabic',
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleDiodrumArabicMedium11(context) {
    return TextStyle(
      color: AppStyles.themeNotifier.value == defaultTheme
          ? const Color(0xffffffff)
          : (AppStyles.themeNotifier.value == lightTheme
              ? Colors.black
              : Colors.white),
      fontSize: getResponsiveFontSize(context, fontSize: 11),
      fontFamily: 'DiodrumArabic',
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleDiodrumArabicbold20(context) {
    return TextStyle(
      color: AppStyles.themeNotifier.value == defaultTheme
          ? const Color(0xffffffff)
          : (AppStyles.themeNotifier.value == lightTheme
              ? Colors.black
              : Colors.white),
      fontSize: getResponsiveFontSize(context, fontSize: 20),
      fontFamily: 'DiodrumArabic',
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle styleRajdhaniMedium13(context) {
    return TextStyle(
      color: AppStyles.themeNotifier.value == defaultTheme
          ? const Color(0xff575757)
          : (AppStyles.themeNotifier.value == lightTheme
              ? Colors.black
              : Colors.white),
      fontSize: getResponsiveFontSize(context, fontSize: 13),
      fontFamily: 'Rajdhani',
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleCairoMedium10(context) {
    return TextStyle(
      color: AppStyles.themeNotifier.value == defaultTheme
          ? Colors.black
          : (AppStyles.themeNotifier.value == lightTheme
              ? Colors.black
              : Colors.white),
      fontSize: getResponsiveFontSize(context, fontSize: 10),
      fontFamily: 'Cairo',
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleUthmanicMedium30(context) {
    return TextStyle(
      fontFamily: 'Uthmanic',
      fontSize: getResponsiveFontSize(context, fontSize: 30),
      color: AppStyles.themeNotifier.value == defaultTheme
          ? AppColors.kSecondaryColor
          : (AppStyles.themeNotifier.value == lightTheme
              ? Colors.black
              : Colors.white),
    );
  }

  static TextStyle styleAmiriMedium11(context) {
    return TextStyle(
      fontFamily: 'Amiri',
      fontSize: getResponsiveFontSize(context, fontSize: 11),
      color: AppStyles.themeNotifier.value == defaultTheme
          ? AppColors.kSecondaryColor
          : (AppStyles.themeNotifier.value == lightTheme
              ? Colors.black
              : Colors.white),
    );
  }
}

// sacleFactor
// responsive font size
// (min , max) fontsize
double getResponsiveFontSize(context, {required double fontSize}) {
  double scaleFactor = getScaleFactor(context);
  double responsiveFontSize = fontSize * scaleFactor;

  double lowerLimit = fontSize * .8;
  double upperLimit = fontSize * 1.2;

  return responsiveFontSize.clamp(lowerLimit, upperLimit);
}

double getScaleFactor(BuildContext context) {
  // var dispatcher = PlatformDispatcher.instance;
  // var physicalWidth = dispatcher.views.first.physicalSize.width;
  // var devicePixelRatio = dispatcher.views.first.devicePixelRatio;
  // double width = physicalWidth / devicePixelRatio;

  double width = MediaQuery.sizeOf(context).width;
  if (width < SizeConfig.tablet) {
    return width / 450;
  } else if (width < SizeConfig.desktop) {
    return width / 800;
  } else {
    return width / 1920;
  }
}
