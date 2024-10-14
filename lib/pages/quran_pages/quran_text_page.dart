import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran/quran.dart' as quran;
import '../../constants.dart';
import '../../utils/app_style.dart';
import '../../utils/app_images.dart';
import '../../widgets/icon_constrain_widget.dart';
import '../../widgets/quran_container_down.dart';

class SurahPage extends StatefulWidget {
  const SurahPage({super.key, required this.surahIndex});
  final int surahIndex;

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  bool isVisible = true;

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
            child: SafeArea(
              child: PageView(
                onPageChanged: (value) {
                  // Change variables of the containers if needed
                },
                children: [
                  GestureDetector(
                    onTap: toggleVisibility,
                    child: const Text(
                      'Here is where surah content should be shown',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isVisible)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(child: QuranContainerUP()),
            ),
          if (isVisible)
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(child: QuranContainerDown()),
            ),
        ],
      ),
    );
  }
}

class QuranContainerUP extends StatelessWidget {
  const QuranContainerUP({super.key});

  @override
  Widget build(BuildContext context) {
    String isMakkia = true ? 'مكية' : 'مدنية';
    int surahsAyat = 288;
    int surahIndex = 1;
    int hizpNumber = 5;
    double rob3HizpNumber = 1 / 4;
    int juzNumber = 3;
    bool isPageLeft = false;

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
                        Text(
                          'سورة ${quran.getSurahNameArabic(surahIndex)} ($isMakkia ،اياتها $surahsAyat)',
                          style: AppStyles.styleDiodrumArabicMedium15(context)
                              .copyWith(color: Colors.white),
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
                        '$rob3HizpNumber الحزب $hizpNumber   ',
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
                'الجزء $juzNumber',
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
