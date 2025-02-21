import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quran/quran.dart' as quran;
import '../../constants.dart';
import '../../utils/app_style.dart';
import '../../utils/app_images.dart';
import '../../widgets/icon_constrain_widget.dart';
import '../cubit/theme_cubit/theme_cubit.dart';

class QuranContainerUP extends StatefulWidget {
  final int surahIndex;
  final String isMakkia;
  final int juzNumber;
  final int surahsAyat;
  final bool isPageLeft;
  final int verseNumber;

  const QuranContainerUP({
    super.key,
    required this.surahIndex,
    required this.isMakkia,
    required this.juzNumber,
    required this.surahsAyat,
    required this.isPageLeft,
    required this.verseNumber,
  });

  @override
  State<QuranContainerUP> createState() => _QuranContainerUPState();
}

class _QuranContainerUPState extends State<QuranContainerUP> {
  @override
  Widget build(BuildContext context) {
    // Get Hizb details
    final hizbDetails =
        calculateHizbDetails(widget.surahIndex, widget.verseNumber);
    int hizbNumber = hizbDetails['hizb'];
    int quarter = hizbDetails['quarter'];

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      height: 91,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.kSecondaryColor.withOpacity(0.87),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Flexible(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 8),
                        const IconConstrain(
                            height: 30, imagePath: Assets.imagesBook),
                        const SizedBox(width: 8),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'سورة ${quran.getSurahNameArabic(widget.surahIndex)} (${widget.isMakkia == 'Makkah' ? 'مكية' : 'مدنية'} ،اياتها ${widget.surahsAyat})',
                            style:
                                AppStyles.styleDiodrumArabicMedium11(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SvgPicture.asset(
                        widget.isPageLeft
                            ? Assets.imagesLeftPage
                            : Assets.imagesRightPage,
                        colorFilter: ColorFilter.mode(
                            AppStyles.styleDiodrumArabicbold20(context).color!,
                            BlendMode.srcIn),
                      ),
                    ),
                    FittedBox(
                      child: Text(
                        'الربع $quarter الحزب $hizbNumber',
                        style: AppStyles.styleDiodrumArabicMedium15(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  final RenderBox overlay = Overlay.of(context)
                      .context
                      .findRenderObject() as RenderBox;
                  final themeCubit = context.read<ThemeCubit>();

                  showMenu(
                    color: AppColors.kSecondaryColor,
                    context: context,
                    position: RelativeRect.fromRect(
                      Rect.fromLTWH(
                        overlay.size.width - 50, // مكان ظهور القائمة
                        50, // ارتفاع القائمة
                        50,
                        50,
                      ),
                      Offset.zero & overlay.size,
                    ),
                    items: [
                      PopupMenuItem(
                        onTap: () =>
                            {themeCubit.setTheme(lightTheme), setState(() {})},
                        child: Text(
                          'الوضع الفاتح',
                          style: AppStyles.styleCairoMedium15white(context),
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () =>
                            {themeCubit.setTheme(darkTheme), setState(() {})},
                        child: Text(
                          'الوضع المظلم',
                          style: AppStyles.styleCairoMedium15white(context),
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () => {
                          themeCubit.setTheme(defaultTheme),
                          setState(() {})
                        },
                        child: Text(
                          'الوضع الافتراضي',
                          style: AppStyles.styleCairoMedium15white(context),
                        ),
                      ),
                    ],
                  );
                },
                icon: Icon(
                  Icons.light_mode,
                  color: AppStyles.styleDiodrumArabicbold20(context).color,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 4 - 20,
              ),
              const IconConstrain(height: 30, imagePath: Assets.imagesVector),
              const SizedBox(width: 8),
              Text(
                'الجزء ${widget.juzNumber}  ',
                style: AppStyles.styleDiodrumArabicMedium15(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Calculates the cumulative verse number up to the given Surah and Verse.
int getCumulativeVerses(int surahNumber, int verseNumber) {
  int totalVerses = 0;

  // Sum up all the verses in previous Surahs
  for (int i = 1; i < surahNumber; i++) {
    totalVerses += quran.getVerseCount(i);
  }

  // Add the verses in the current Surah up to the specified verse
  totalVerses += verseNumber;

  return totalVerses;
}

const int totalVersesInQuran = 6236;

/// Calculates the Hizb and its quarter for a given Surah and Verse.
/// Returns a map containing the Juz, Hizb number, and quarter of the Hizb.
/// Calculates the Hizb and its quarter for a given Surah and Verse.
/// Returns a map containing the Juz, Hizb number, and quarter of the Hizb.
Map<String, dynamic> calculateHizbDetails(int surahNumber, int verseNumber) {
  // Get the Juz number for the verse
  int juzNumber = quran.getJuzNumber(surahNumber, verseNumber);

  // Calculate the cumulative verse number up to this point
  int cumulativeVerseNumber = getCumulativeVerses(surahNumber, verseNumber);

  // Each Juz has two Hizbs, and the Quran contains 60 Hizbs
  int hizbNumber =
      ((cumulativeVerseNumber - 1) ~/ (totalVersesInQuran ~/ 60)) + 1;

  // Calculate the position within the Hizb (1/4, 2/4, etc.)
  int versesInHizb = totalVersesInQuran ~/ 60; // Average verses per Hizb
  int quarter =
      (((cumulativeVerseNumber - 1) % versesInHizb) ~/ (versesInHizb / 4)) + 1;

  return {
    'juz': juzNumber,
    'hizb': hizbNumber,
    'quarter': quarter, // Values: 1, 2, 3, or 4
  };
}
