import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran/quran.dart' as quran;
import '../../constants.dart';
import '../../utils/app_style.dart';
import '../../utils/app_images.dart';
import '../../widgets/icon_constrain_widget.dart';

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
              color: Colors.transparent, // Ensure the body area is tappable
              child: const Center(
                child: const Text(
                  'This is the body area. Tap here to hide/show the containers.',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          if (isVisible)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: SafeArea(
                    child: QuranContainerUP(surahIndex: widget.surahIndex)),
              ),
            ),
          if (isVisible)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: SafeArea(
                    child: QuranContainerDown(surahIndex: widget.surahIndex)),
              ),
            ),
        ],
      ),
    );
  }
}

class QuranContainerUP extends StatelessWidget {
  const QuranContainerUP({
    super.key,
    required this.surahIndex,
    this.child,
  });
  final Widget? child;
  final int surahIndex;

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
                          'سورة ${quran.getSurahNameArabic(surahIndex)} (مكية ،اياتها 286)',
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
                        Assets.imagesRightPage,
                      ),
                    ),
                    FittedBox(
                      child: Text(
                        '1/4 الحزب 5   ',
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
                'الجزء 3',
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

class QuranContainerDown extends StatelessWidget {
  const QuranContainerDown({super.key, required this.surahIndex});
  final int surahIndex;

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
                      hintText: 'إبحث عن آية',
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
                onTap: () {},
              ),
              QuranContainerButtons(
                iconHeight: 15.3,
                iconPath: Assets.imagesVector,
                text: 'الأجزاء',
                onTap: () {},
              ),
              QuranContainerButtons(
                iconHeight: 16.4,
                iconPath: Assets.imagesHand,
                text: 'دعاء الختم',
                onTap: () {},
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

