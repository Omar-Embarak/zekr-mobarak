import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:al_quran/al_quran.dart';
import 'package:quran/page_data.dart';
import '../../constants.dart';
import '../../widgets/quran_container_down.dart';
import '../../widgets/quran_container_up.dart';
import 'package:quran/quran.dart' as quran;

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
  Map<int, List<Map<String, dynamic>>> pageContent = {};
  int currentSurahIndex = 0;
  int currentJuzNumber = 0;

  @override
  void initState() {
    super.initState();
    _loadPageContent(widget.pageNumber); // Load initial page content
  }

  // Function to load the page content based on page number
  Future<void> _loadPageContent(int pageNumber) async {
    try {
      // Clear previous content
      pageContent.clear();

      // Retrieve the content for the specific page
      List<Map<String, dynamic>> currentPageData = pageData[pageNumber - 1];

      for (var entry in currentPageData) {
        int surahNumber = entry['surah'];
        int startVerse = entry['start'];
        int endVerse = entry['end'];

        // Track current Surah and Juz for QuranContainerUP
        currentSurahIndex = surahNumber;
        currentJuzNumber = quran.getJuzNumber(surahNumber, startVerse);

        // Create a list of verse information, including actual verse numbers
        List<Map<String, dynamic>> verses = [];
        for (int verse = startVerse; verse <= endVerse; verse++) {
          verses.add({
            'verseNumber': verse,
            'verseText': quran.getVerse(surahNumber, verse),
          });
        }
        pageContent[surahNumber] = verses;
      }

      setState(() {}); // Refresh UI
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
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
            child: SafeArea(
              child: PageView.builder(
                controller: PageController(initialPage: widget.pageNumber - 1),
                onPageChanged: (newPageIndex) {
                  setState(() {
                    widget.pageNumber = newPageIndex + 1;
                  });
                  _loadPageContent(widget.pageNumber); // Load new page content
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: toggleVisibility,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(
                                  fontFamily:
                                      'Amiri', // Use the family name specified in pubspec.yaml
                                  color: AppColors.kSecondaryColor,
                                  fontSize: 22.0,
                                  height: 1.5,
                                ),
                                children: [
                                  ...pageContent.entries.expand((entry) {
                                    int surahNumber = entry.key;
                                    return entry.value.map((verseEntry) {
                                      int verseIndex =
                                          verseEntry['verseNumber'];
                                      String verseText =
                                          verseEntry['verseText'];

                                      // Conditional check to display Bismillah only before the first verse of each Surah
                                      List<TextSpan> textSpans = [];

                                      // Show Surah name and Bismillah only if the verseIndex is 1 and not Surah Al-Fatihah
                                      if (verseIndex == 1 &&
                                          currentSurahIndex != 1) {
                                        textSpans.add(TextSpan(
                                          text:
                                              '\n سورة ${quran.getSurahNameArabic(surahNumber)}\n',
                                          style: const TextStyle(
                                            fontFamily:
                                                'Amiri', // Use the family name specified in pubspec.yaml
                                            color: AppColors.kSecondaryColor,
                                            fontSize: 22.0,
                                            height: 1.5,
                                          ),
                                        ));
                                        textSpans.add(TextSpan(
                                          text:
                                              '${AlQuran.getBismillah.unicode}\n\n',
                                          style: const TextStyle(
                                            fontFamily:
                                                'Amiri', // Use the family name specified in pubspec.yaml
                                            color: AppColors.kSecondaryColor,
                                            fontSize: 22.0,
                                            height: 1.5,
                                          ),
                                        ));
                                      }
                                      textSpans.add(TextSpan(
                                        text:
                                            ' $verseText${quran.getVerseEndSymbol(verseIndex, arabicNumeral: true)} ',
                                      ));
                                      return textSpans;
                                    }).expand((e) => e); // Flatten nested list
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Upper container with dynamic surah and juz info
          if (isVisible)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: QuranContainerUP(
                  surahIndex: currentSurahIndex,
                  isMakkia: quran.getPlaceOfRevelation(currentSurahIndex),
                  juzNumber: currentJuzNumber - 1,
                  surahsAyat: quran.getVerseCount(currentSurahIndex),
                  isPageLeft: widget.pageNumber % 2 == 0,
                ),
              ),
            ),
          // Bottom container with page number
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

  // Function to toggle visibility of upper and lower containers
  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }
}
