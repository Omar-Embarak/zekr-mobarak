import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import '../utils/app_images.dart';
import '../utils/app_style.dart';

class SurahBorder extends StatelessWidget {
  const SurahBorder({
    super.key,
    required this.surahNumber,
  });

  final int surahNumber;

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
            style: AppStyles.styleAmiriMedium30(context).copyWith(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
