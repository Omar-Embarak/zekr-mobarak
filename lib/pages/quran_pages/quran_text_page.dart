import 'package:azkar_app/pages/quran_pages/juz_page.dart';
import 'package:azkar_app/widgets/surahs_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran/quran.dart' as quran;
import '../../constants.dart';
import '../../utils/app_style.dart';
import '../../utils/app_images.dart';
import '../../widgets/icon_constrain_widget.dart';
import 'doaa_khatm_page.dart';

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
          GestureDetector(
            onTap: toggleVisibility,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
              child: SafeArea(
                child: PageView(
                  onPageChanged: (value) {
                    //change variables of the containers
                  },
                  children: const [
                    Text(
                      'Here is where surah content should be showen',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isVisible)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: SafeArea(child: QuranContainerUP()),
              ),
            ),
          if (isVisible)
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: SafeArea(child: QuranContainerDown()),
              ),
            ),
        ],
      ),
    );
  }
}

class QuranContainerUP extends StatefulWidget {
  const QuranContainerUP({
    super.key,
  });
  @override
  State<QuranContainerUP> createState() => _QuranContainerUPState();
}

class _QuranContainerUPState extends State<QuranContainerUP> {
  String isMakkia = true ? 'مكية' : 'مدنية'; //check here for the surah
  int surahsAyat = 288;
  int surahIndex = 1;
  int hizpNumber = 5;
  double rob3HizpNumber = 1 / 4;
  int juzNumber = 3;

  bool isPageLeft = false;

  @override
  Widget build(BuildContext context) {
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

class QuranContainerDown extends StatefulWidget {
  const QuranContainerDown({super.key});

  @override
  State<QuranContainerDown> createState() => _QuranContainerDownState();
}

class _QuranContainerDownState extends State<QuranContainerDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      height: 136,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.kSecondaryColor.withOpacity(0.87),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Flexible(
                flex: 3,
                child: SizedBox(
                  height: 35,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText:
                          'إبحث عن آية', //this field for search for any aya in the quran , the keyboard should push the container up
                      hintStyle: AppStyles.styleDiodrumArabicMedium15(context)
                          .copyWith(color: Colors.white),
                      suffixIcon: const IconConstrain(
                          height: 26, imagePath: Assets.imagesSearch),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: const Color(0x66CFAD65),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  height: 35,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        const IconConstrain(
                          imagePath: Assets.imagesSave,
                          height: 22,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'حفظ علامة ',
                          style: AppStyles.styleDiodrumArabicMedium15(context)
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              QuranContainerButtons(
                iconHeight: 15,
                iconPath: Assets.imagesSaveFilled,
                text: 'الإنتقال إلي العلامة',
                onTap: () {},
              ),
              QuranContainerButtons(
                iconHeight: 18,
                iconPath: Assets.imagesPage,
                text: 'تغيير الصفحة',
                onTap: () {},
              ),
            ],
          ),
          Row(
            children: [
              QuranContainerButtons(
                iconHeight: 10.07,
                iconPath: Assets.imagesIndex,
                text: 'الفهرس',
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        SurahListWidget(onSurahTap: (surahIndex) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SurahPage(surahIndex: surahIndex),
                        ),
                      );
                    }),
                  ));
                },
              ),
              QuranContainerButtons(
                iconHeight: 15.3,
                iconPath: Assets.imagesVector,
                text: 'الأجزاء',
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const JuzListPage(),
                  ));
                },
              ),
              QuranContainerButtons(
                iconHeight: 16.4,
                iconPath: Assets.imagesHand,
                text: 'دعاء الختم',
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DoaaKhatmPage(),
                  ));
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

class QuranContainerButtons extends StatelessWidget {
  const QuranContainerButtons({
    super.key,
    required this.onTap,
    required this.text,
    required this.iconPath,
    required this.iconHeight,
  });
  final void Function() onTap;
  final String text;
  final String iconPath;
  final double iconHeight;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            IconConstrain(height: iconHeight, imagePath: iconPath),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: AppStyles.styleDiodrumArabicMedium15(context)
                  .copyWith(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
