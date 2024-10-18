import 'dart:developer';

import 'package:azkar_app/methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran/quran.dart' as quran;
import '../../constants.dart';
import '../../utils/app_style.dart';
import '../../utils/app_images.dart';
import '../../widgets/icon_constrain_widget.dart';
import '../../widgets/quran_container_down.dart';

class SurahPage extends StatefulWidget {
  SurahPage({
    super.key,
    required this.surahIndex,
    required this.isMakkia,
    required this.juzNumber,
    required this.surahsAyat,
  });
  int surahIndex;
  int juzNumber;
  String isMakkia;
  int surahsAyat; //number of verses in each surah

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  bool isVisible = true;

  List surahContent = [];

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSurahContent();
  }

  Future<void> _loadSurahContent() async {
    // Load the JSON data
    final data = await loadJSONDataMap(
        'assets/quranjson/surah/surah_${widget.surahIndex}.json');

    // Check the type of the data['verse'] and confirm it's a Map
    try {
      if (data['verse'] is Map<String, dynamic>) {
        final verseData = data['verse'] as Map<String, dynamic>;

        // Clear the existing content
        surahContent.clear();

        // Iterate over each key-value pair in the map
        verseData.forEach((key, value) {
          // Add the verse content (the value part of the key-value pair)
          surahContent.add(value.toString());
        });

        // Update the state to reflect the changes
        setState(() {});
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
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
                    child: surahContent.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            itemCount: surahContent.length,
                            itemBuilder: (context, index) {
                              return Text(
                                '${surahContent[index]}',
                                style: AppStyles.styleRajdhaniBold20(context)
                                    .copyWith(color: AppColors.kSecondaryColor),
                                textAlign: TextAlign.center,
                              );
                            }),
                  ),
                ],
              ),
            ),
          ),
          if (isVisible)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                  child: QuranContainerUP(
                surahsAyat: widget.surahsAyat, //number of verses in each surah

                juzNumber: widget.juzNumber,
                surahIndex: widget.surahIndex,
                isMakkia: widget.isMakkia,
              )),
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

class QuranContainerUP extends StatefulWidget {
  QuranContainerUP(
      {super.key,
      required this.surahIndex,
      required this.isMakkia,
      required this.juzNumber,
      required this.surahsAyat});
  int surahIndex;
  String isMakkia;
  int juzNumber;
  int surahsAyat; //number of verses in each surah

  @override
  State<QuranContainerUP> createState() => _QuranContainerUPState();
}

class _QuranContainerUPState extends State<QuranContainerUP> {
  @override
  Widget build(BuildContext context) {
    int hizpNumber = 5;
    double rob3HizpNumber = 1 / 4;
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
                          'سورة ${quran.getSurahNameArabic(widget.surahIndex)} (${widget.isMakkia} ،اياتها ${widget.surahsAyat})',
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
                        '$rob3HizpNumber الحزب $hizpNumber   ', //رقم الحزب ورقم الربع
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
                'الجزء ${widget.juzNumber + 1}',
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
