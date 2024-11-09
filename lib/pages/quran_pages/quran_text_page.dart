import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:al_quran/al_quran.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../methods.dart';
import '../../utils/app_style.dart';
import '../../widgets/quran_container_down.dart';
import '../../widgets/quran_container_up.dart';
import 'package:quran/quran.dart' as quran;
import 'quran_data_provider.dart'; // Import the QuranDataProvider file

class SurahPage extends StatefulWidget {
  final int surahIndex;
  final int juzNumber;
  final String isMakkia;
  final int surahsAyat;
  int pageNumber;
   SurahPage({
    super.key,
    required this.surahIndex,
    required this.juzNumber,
    required this.isMakkia,
    required this.surahsAyat,
    required this.pageNumber,
  });

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  bool isVisible = true;
  bool isPageLeft = true;
  Map<int, List<String>> pageContent = {};

  @override
  void initState() {
    super.initState();
    _loadPageContent();
  }

  Future<void> _loadPageContent() async {
    try {
      final data = await loadJSONDataMap(
          'assets/quranjson/surah/surah_${widget.surahIndex}.json');

      if (data['verse'] is Map<String, dynamic>) {
        final verseData = data['verse'] as Map<String, dynamic>;

        int currentPage = 0;
        List<String> verses = [];

        verseData.forEach((key, value) {
          verses.add(value.toString());
          if (verses.length >= 10) {
            pageContent[currentPage] = List<String>.from(verses);
            verses.clear();
            currentPage++;
          }
        });

        if (verses.isNotEmpty) {
          pageContent[currentPage] = List<String>.from(verses);
        }

        setState(() {});
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final juzData = Provider.of<QuranDataProvider>(context)
        .juzData; // Juz data from provider

    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
            child: SafeArea(
              child: PageView.builder(
                itemCount: pageContent.length,
                onPageChanged: (value) {
                  setState(() {
                    isPageLeft = !isPageLeft;
                  });
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: toggleVisibility,
                    child: ListView.builder(
                      itemCount: pageContent[index]?.length ?? 0,
                      itemBuilder: (context, verseIndex) {
                        final verseText = (verseIndex == 0)
                            ? AlQuran.getBismillah.unicode
                            : '${pageContent[index]?[verseIndex]} ${quran.getVerseEndSymbol(verseIndex,arabicNumeral: true)}';

                        return Text(
                          verseText,
                          style: AppStyles.styleRajdhaniBold20(context)
                              .copyWith(color: AppColors.kSecondaryColor),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  );
                },
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
                  surahsAyat: widget.surahsAyat,
                  juzNumber: widget.juzNumber,
                  surahIndex: widget.surahIndex,
                  isMakkia: widget.isMakkia,
                  isPageLeft: isPageLeft,
                ),
              ),
            ),
          if (isVisible)
             Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                  child: QuranContainerDown(
                pageNumber: widget.pageNumber,
              )),
            ),
        ],
      ),
    );
  }

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }
}
