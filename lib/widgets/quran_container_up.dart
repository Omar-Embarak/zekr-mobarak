import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran/quran.dart' as quran;
import '../../constants.dart';
import '../../utils/app_style.dart';
import '../../utils/app_images.dart';
import '../../widgets/icon_constrain_widget.dart';

class QuranContainerUP extends StatelessWidget {
  final int surahIndex;
  final String isMakkia;
  final int juzNumber;
  final int surahsAyat;
  final bool isPageLeft;

  const QuranContainerUP({
    super.key,
    required this.surahIndex,
    required this.isMakkia,
    required this.juzNumber,
    required this.surahsAyat,
    required this.isPageLeft,
  });

  @override
  Widget build(BuildContext context) {
    int hizpNumber = 5;
    double rob3HizpNumber = 1 / 4;

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
                            'سورة ${quran.getSurahNameArabic(surahIndex)} (${isMakkia == 'Makkah' ? 'مكية' : 'مدنية'} ،اياتها $surahsAyat)',
                            style: AppStyles.styleDiodrumArabicMedium15(context)
                                .copyWith(color: Colors.white),
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
                        isPageLeft
                            ? Assets.imagesLeftPage
                            : Assets.imagesRightPage,
                      ),
                    ),
                    FittedBox(
                      child: Text(
                        '$rob3HizpNumber الحزب $hizpNumber',
                        style: AppStyles.styleDiodrumArabicMedium15(context)
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const IconConstrain(height: 30, imagePath: Assets.imagesVector),
              const SizedBox(width: 8),
              Text(
                'الجزء ${juzNumber + 1}',
                style: AppStyles.styleDiodrumArabicMedium15(context)
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
