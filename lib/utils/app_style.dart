import 'package:flutter/material.dart';

import 'size_config.dart';

abstract class AppStyles {
  static const TextStyle styleCairoMedium15 = TextStyle(
    color: Color(0xff6A564F),
    fontSize: 15,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.w500,
  );
  static const TextStyle styleRajdhaniMedium20 = TextStyle(
    color: Color(0xff6A564F),
    fontSize: 20,
    fontFamily: 'Rajdhani',
    fontWeight: FontWeight.w500,
  );
  static const TextStyle styleRajdhaniMedium18 = TextStyle(
    color: Color(0xff575757),
    fontSize: 18,
    fontFamily: 'Rajdhani',
    fontWeight: FontWeight.w500,
  );
  static const TextStyle styleRajdhaniBold20 = TextStyle(
    color: Color(0xff6A564F),
    fontSize: 20,
    fontFamily: 'Rajdhani',
    fontWeight: FontWeight.w700,
  );
  static const TextStyle styleRajdhaniBold13 = TextStyle(
    color: Color(0xff575757),
    fontSize: 13,
    fontFamily: 'Rajdhani',
    fontWeight: FontWeight.w700,
  );
  static const TextStyle styleRajdhaniBold18 = TextStyle(
    color: Color(0xff575757),
    fontSize: 18,
    fontFamily: 'Rajdhani',
    fontWeight: FontWeight.w700,
  );
  static const TextStyle styleRajdhaniMedium15 = TextStyle(
    color: Color(0xff000000),
    fontSize: 15,
    fontFamily: 'Rajdhani',
    fontWeight: FontWeight.w500,
  );
  static const TextStyle styleDiodrumArabicMedium15 = TextStyle(
    color: Color(0xff000000),
    fontSize: 15,
    fontFamily: 'DiodrumArabic',
    fontWeight: FontWeight.w500,
  );
  static const TextStyle styleRajdhaniMeduim13 = TextStyle(
    color: Color(0xff575757),
    fontSize: 13,
    fontFamily: 'Rajdhani',
    fontWeight: FontWeight.w500,
  );
   static const TextStyle styleCairoBold20 = TextStyle(
    color: Color(0xffFFFFFF),
    fontSize: 20,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.w700,
  );
   static const TextStyle styleCairoMeduim10 = TextStyle(
    color: Color(0xff6A564F),
    fontSize: 10,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.w500,
  );
 
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
    return width / 550;
  } else if (width < SizeConfig.desktop) {
    return width / 1000;
  } else {
    return width / 1920;
  }
}