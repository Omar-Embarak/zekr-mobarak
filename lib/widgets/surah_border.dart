import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final fontSize = context.watch<QuranFontSizeProvider>().fontSize - 10;

    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(Assets.imagesSurahBorder),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'سورة ${quran.getSurahNameArabic(surahNumber)}',
            style: AppStyles.styleUthmanicMedium30(context)
                .copyWith(fontSize: fontSize > 50 ? 50 : fontSize),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
