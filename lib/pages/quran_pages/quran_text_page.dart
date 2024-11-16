// Import statements
import 'dart:developer';
import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:quran/page_data.dart';
import '../../constants.dart';
import '../../widgets/basmalla_widget.dart';
import '../../widgets/quran_container_down.dart';
import '../../widgets/quran_container_up.dart';
import 'package:quran/quran.dart' as quran;
import '../../widgets/surah_border.dart';

class SurahPage extends StatefulWidget {
  int pageNumber;

  SurahPage({
    super.key,
    required this.pageNumber,
  });

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  bool isVisible = true;
  Map<int, List<Map<String, dynamic>>> pageContent = {};
  int currentSurahIndex = 0;
  int currentJuzNumber = 0;

  @override
  void initState() {
    super.initState();
    _loadPageContent(widget.pageNumber);
  }

  Future<void> _loadPageContent(int pageNumber) async {
    try {
      pageContent.clear();
      List<Map<String, dynamic>> currentPageData = pageData[pageNumber - 1];

      for (var entry in currentPageData) {
        int surahNumber = entry['surah'];
        int startVerse = entry['start'];
        int endVerse = entry['end'];
        currentSurahIndex = surahNumber;
        currentJuzNumber = quran.getJuzNumber(surahNumber, startVerse) - 1;

        List<Map<String, dynamic>> verses = [];
        for (int verse = startVerse; verse <= endVerse; verse++) {
          verses.add({
            'verseNumber': verse,
            'verseText': quran.getVerse(surahNumber, verse),
          });
        }
        pageContent[surahNumber] = verses;
      }

      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      body: Stack(
        children: [
          SafeArea(
            child: PageView.builder(
              controller: PageController(initialPage: widget.pageNumber - 1),
              onPageChanged: (newPageIndex) {
                setState(() {
                  widget.pageNumber = newPageIndex + 1;
                });
                _loadPageContent(widget.pageNumber);
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: toggleVisibility,
                  child: Container(
                    // If isCentered is false, use EdgeInsets.zero padding to fill the entire screen
                    padding: const EdgeInsets.only(right: 8, top: 8),
                    alignment: Alignment.center,
                    child: Text.rich(
                      softWrap: true,
                      TextSpan(
                        style: AppStyles.styleAmiriMedium20(context),
                        children: [
                          ...pageContent.entries.expand((entry) {
                            int surahNumber = entry.key;
                            return entry.value.map((verseEntry) {
                              int verseIndex = verseEntry['verseNumber'];
                              String verseText = verseEntry['verseText'];

                              List<InlineSpan> inlineSpans = [];
                              if (verseIndex == 1 && currentSurahIndex == 1) {
                                inlineSpans.add(
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child:
                                        SurahBorder(surahNumber: surahNumber),
                                  ),
                                );
                              }

                              if (verseIndex == 1 && currentSurahIndex != 1) {
                                inlineSpans.add(
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child:
                                        SurahBorder(surahNumber: surahNumber),
                                  ),
                                );
                                // Inside your text span
                                inlineSpans.add(
                                  bamallaWidget(context),
                                );
                              }

                              inlineSpans.add(TextSpan(
                                text:
                                    ' $verseText${quran.getVerseEndSymbol(verseIndex, arabicNumeral: true)} ',
                              ));

                              return inlineSpans;
                            }).expand((e) => e);
                          }),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (isVisible)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: QuranContainerUP(
                  surahIndex: currentSurahIndex,
                  isMakkia: quran.getPlaceOfRevelation(currentSurahIndex),
                  juzNumber: currentJuzNumber,
                  surahsAyat: quran.getVerseCount(currentSurahIndex),
                  isPageLeft: widget.pageNumber % 2 == 0,
                  verseNumber: int.parse(
                      (pageData[widget.pageNumber][0]['start']).toString()),
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
                ),
              ),
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
