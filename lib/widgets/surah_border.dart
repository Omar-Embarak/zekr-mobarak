import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import '../pages/quran_pages/quran_font_size_provider.dart';
import '../utils/app_images.dart';
import '../utils/app_style.dart';

class SurahBorder extends StatelessWidget {
  const SurahBorder({
    super.key,
    required this.surahNumber,
  });

  final int surahNumber;
// final double fontSize=QuranFontSizeProvider.fontSize;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(Assets.imagesSurahBorder),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'سورة ${quran.getSurahNameArabic(surahNumber)}',
            style: AppStyles.styleAmiriMedium30(context).copyWith(fontSize: 22),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
