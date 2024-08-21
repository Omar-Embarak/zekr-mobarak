import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran/quran.dart' as quran;
import '../../constants/colors.dart';
import '../../utils/app_images.dart';

class SurahPage extends StatelessWidget {
  const SurahPage({super.key, required this.surahIndex});
  final int surahIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QuranDecorationContainer(surahIndex: surahIndex),
    );
  }
}

class QuranDecorationContainer extends StatelessWidget {
  const QuranDecorationContainer({
    super.key,
    required this.surahIndex,
  });

  final int surahIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      height: 91,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.kSecondaryColor.withOpacity(0.87),
        borderRadius: BorderRadius.circular(7),
      ),
      child: QuranContainerUP(surahIndex: surahIndex),
    );
  }
}

class QuranContainerUP extends StatelessWidget {
  const QuranContainerUP({
    super.key,
    required this.surahIndex,
  });

  final int surahIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Text(
                  'الجزء 3',
                  style: AppStyles.styleDiodrumArabicMedium15(context)
                      .copyWith(color: Colors.white),
                ),
                // SvgPicture.asset(Assets.imagesVector)
              ],
            ),
            Spacer(),
            Row(
              children: [
                // SvgPicture.asset(Assets.imagesBook),
                Text(
                  'سورة ${quran.getSurahNameArabic(surahIndex)} (مكية ،اياتها 286)',
                  style: AppStyles.styleDiodrumArabicMedium15(context)
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(Assets.imagesRightPage),
            Text(
              '1/4 لحزب 5',
              style: AppStyles.styleDiodrumArabicMedium15(context)
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
