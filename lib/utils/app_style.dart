import 'package:flutter/material.dart';

import 'size_config.dart';

abstract class AppStyles {
  static TextStyle styleCairoMedium15(context) {
    return TextStyle(
      color: const Color(0xff6A564F),
      fontSize: getResponsiveFontSize(context, fontSize: 15),
      fontFamily: 'Cairo',
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleRajdhaniMedium20(context) {
    return TextStyle(
      color: const Color(0xff6A564F),
      fontSize: getResponsiveFontSize(context, fontSize: 20),
      fontFamily: 'Rajdhani',
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleRajdhaniMedium18(context) {
    return TextStyle(
      color: const Color(0xff575757),
      fontSize: getResponsiveFontSize(context, fontSize: 18),
      fontFamily: 'Rajdhani',
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleRajdhaniBold20(context) {
    return TextStyle(
      color: const Color(0xff6A564F),
      fontSize: getResponsiveFontSize(context, fontSize: 20),
      fontFamily: 'Rajdhani',
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle styleRajdhaniBold13(context) {
    return TextStyle(
      color: const Color(0xff575757),
      fontSize: getResponsiveFontSize(context, fontSize: 13),
      fontFamily: 'Rajdhani',
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle styleRajdhaniBold18(context) {
    return TextStyle(
      color: const Color(0xff575757),
      fontSize: getResponsiveFontSize(context, fontSize: 18),
      fontFamily: 'Rajdhani',
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle styleRajdhaniMedium15(context) {
    return TextStyle(
      color: const Color(0xff000000),
      fontSize: getResponsiveFontSize(context, fontSize: 15),
      fontFamily: 'Rajdhani',
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleDiodrumArabicMedium15(context) {
    return TextStyle(
      color: const Color(0xff000000),
      fontSize: getResponsiveFontSize(context, fontSize: 15),
      fontFamily: 'DiodrumArabic',
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleRajdhaniMedium13(context) {
    return TextStyle(
      color: const Color(0xff575757),
      fontSize: getResponsiveFontSize(context, fontSize: 13),
      fontFamily: 'Rajdhani',
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleCairoBold20(context) {
    return TextStyle(
      color: const Color(0xffFFFFFF),
      fontSize: getResponsiveFontSize(context, fontSize: 20),
      fontFamily: 'Cairo',
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle styleCairoMedium10(context) {
    return TextStyle(
      color: const Color(0xff6A564F),
      fontSize: getResponsiveFontSize(context, fontSize: 10),
      fontFamily: 'Cairo',
      fontWeight: FontWeight.w500,
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

double getScaleFactor(context) {
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
