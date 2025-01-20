import 'dart:math';

import 'package:al_quran/al_quran.dart';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quran/page_data.dart';
import 'package:quran/quran.dart' as quran;
import 'package:audioplayers/audioplayers.dart';
import '../../constants.dart';
import '../../cubit/theme_cubit/theme_cubit.dart';
import '../../methods.dart';
import '../../no_scroll_beyond_physics.dart';
import '../../utils/app_style.dart';
import '../../widgets/quran_container_down.dart';
import '../../widgets/quran_container_up.dart';
import '../../widgets/surah_border.dart';
import '../../widgets/verse_buttons_widget.dart';
import 'quran_font_size_provider.dart';
import 'quran_reading_main_page.dart';

class SurahPage extends StatefulWidget {
  final int pageNumber;

  const SurahPage({super.key, required this.pageNumber});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  bool isVisible = true;
  Map<int, List<Map<String, dynamic>>> pageContent = {};
  int currentSurahIndex = 0;
  int currentJuzNumber = 0;
  int? highlightedVerse;
  Offset? buttonPosition;
  late int pageNumber;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isBuffering = false;
  late final PageController _pageController;
  Map<int, Map<int, bool>> highlightedVerses =
      {}; // Map<SurahNumber, Map<VerseNumber, isHighlighted>>

  @override
  void initState() {
    super.initState();
    pageNumber = widget.pageNumber;
    _loadPageContent(pageNumber);
    _pageController = PageController(
      initialPage: pageNumber - 1,
    );

    _preloadAudio();
  }

  double _getAdjustedFontSize(String text, double originalFontSize) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(fontSize: originalFontSize),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    textPainter.layout(minWidth: 0, maxWidth: double.infinity);

    double width = textPainter.width;
    double screenWidth = MediaQuery.of(context).size.width;

    // Adjust scaling factors for wider scaling
    double scaleFactor = 1.0;

    // Wider scaling down if the text is much larger than the screen width
    if (width > screenWidth) {
      scaleFactor = (screenWidth / width) * 0.1; // Increased reduction
    }
    // Wider scaling up if the text is much smaller than the screen width
    else if (width < screenWidth * 0.1) {
      scaleFactor = (screenWidth / width) * 3; // Increased increment
    }

    // Adjust the font size and clamp it within reasonable bounds
    double adjustedFontSize = originalFontSize * scaleFactor;
    return adjustedFontSize.clamp(
        originalFontSize - 6, originalFontSize + 6); // Wider range
  }

  Future<void> _loadPageContent(int pageNumber) async {
    try {
      pageContent.clear();
      List<Map<String, dynamic>> currentPageData = pageData[pageNumber - 1];
      for (var entry in currentPageData) {
        int surahNumber = entry['surah'];
        int startVerse = entry['start'];
        int endVerse = entry['end'];

        currentJuzNumber = quran.getJuzNumber(surahNumber, startVerse);

        List<Map<String, dynamic>> verses = [];
        for (int verse = startVerse; verse <= endVerse; verse++) {
          verses.add({
            'verseNumber': verse,
            'verseText': quran.getVerse(surahNumber, verse),
          });
        }
        pageContent[surahNumber] = verses;
      }

      // Determine the currentSurahIndex based on the first surah of the page
      if (currentPageData.isNotEmpty) {
        currentSurahIndex = currentPageData.first['surah'];
      }
      setState(() {});
    } catch (e) {
      showMessage("تعذر تحميل الصفحة $e");
    }
  }

  void _preloadAudio() async {
    try {
      String audioUrl =
          quran.getAudioURLByVerse(currentSurahIndex, highlightedVerse ?? 1);
      await _audioPlayer.setSourceUrl(audioUrl);
    } catch (e) {
      debugPrint("Error preloading audio: $e");
    }
  }

  void _selectVerse(Offset globalPosition, int verseNumber, int surahNumber) {
    setState(() {
      highlightedVerses.clear(); // Clear previous highlights
      highlightedVerse = verseNumber;
      buttonPosition = globalPosition;

      highlightedVerses[surahNumber] = {
        verseNumber: true,
      }; // Highlight new verse

      // Set the currentSurahIndex to the surah of the selected verse
      currentSurahIndex = surahNumber;
    });
  }

  void _clearSelection() {
    setState(() {
      highlightedVerses.clear();
      buttonPosition = null;
    });
  }

  void _containersVisability() {
    isVisible = !isVisible;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, String>(builder: (context, themeMode) {
// Default theme color

      return PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, Object? result) async {
            // Navigate to QuranReadingMainPage
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const QuranReadingMainPage()),
              (route) => false, // Clear all previous routes
            );
          },
          child: Scaffold(
            backgroundColor: AppColors.kPrimaryColor,
            body: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    _clearSelection();
                    _containersVisability();
                  },
                  child: SafeArea(
                      child: PageView.builder(
                    physics: const NoScrollBeyondPhysics(maxPage: 604),
                    controller: _pageController,
                    onPageChanged: (newPageIndex) {
                      if (newPageIndex < 604) {
                        setState(() {
                          pageNumber = newPageIndex + 1;
                          highlightedVerse = null;
                          _loadPageContent(pageNumber);
                        });
                      } else {
                        _pageController.jumpToPage(
                            603); // Ensure it stays on the last page
                      }
                    },
                    itemBuilder: (context, index) {
                      // Check if the index is within the valid range
                      if (index >= 0 && index < 604) {
                        return _buildPageContent();
                      } else {
                        // Return an empty widget for out-of-bounds pages
                        return Container(
                          color: AppColors
                              .kPrimaryColor, // Match the background color
                        );
                      }
                    },
                  )),
                ),
                if (highlightedVerse != null && buttonPosition != null)
                  _buildActionButtons(),
                if (isVisible) _buildTopHeader(),
                if (isVisible) _buildBottomFooter(),
              ],
            ),
          ));
    });
  }

  Widget _buildPageContent() {
    return Consumer<QuranFontSizeProvider>(
      builder: (context, fontSizeProvider, child) {
        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppStyles.styleUthmanicMedium30(context).copyWith(
                    fontSize: fontSizeProvider.fontSize,
                  ),
                  children: pageContent.entries.expand((entry) {
                    int surahNumber = entry.key;
                    return entry.value.map((verseEntry) {
                      int verseIndex = verseEntry['verseNumber'];
                      String verseText = verseEntry['verseText'];
                      bool isHighlighted =
                          highlightedVerses[surahNumber]?[verseIndex] ?? false;

                      // Split the verse text into words
                      List<String> words = verseText.split(' ');

                      // Create spans for each word with adjusted font sizes
                      List<InlineSpan> wordSpans = words.map((word) {
                        double adjustedFontSize = _getAdjustedFontSize(
                            word, fontSizeProvider.fontSize);

                        return TextSpan(
                          text: '$word ',
                          style: TextStyle(
                            fontSize: adjustedFontSize,
                            backgroundColor: isHighlighted
                                ? Colors.yellow.withOpacity(0.4)
                                : Colors.transparent,
                            color: isHighlighted ? Colors.red : null,
                          ),
                          recognizer: LongPressGestureRecognizer()
                            ..onLongPressStart = (details) {
                              RenderBox renderBox =
                                  context.findRenderObject() as RenderBox;
                              Offset globalPosition = renderBox
                                  .localToGlobal(details.globalPosition);

                              _selectVerse(
                                  globalPosition, verseIndex, surahNumber);
                            },
                        );
                      }).toList();

                      // Manually add the verse end symbol with number only
                      wordSpans.add(TextSpan(
                        text:
                            '${quran.getVerseEndSymbol(verseIndex, arabicNumeral: true)} ',
                        style: TextStyle(
                          fontSize: fontSizeProvider.fontSize,
                          fontFamily: "Amiri",
                        ),
                      ));

                      return TextSpan(
                        children: [
                          if (verseIndex == 1) ...[
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: SurahBorder(surahNumber: surahNumber),
                            ),
                            if (surahNumber != 1 && surahNumber != 9)
                              TextSpan(
                                text: '${AlQuran.getBismillah.unicode}\n\n',
                                style: AppStyles.styleAmiriMedium11(context)
                                    .copyWith(
                                  height: 1,
                                  fontSize:
                                      min(fontSizeProvider.fontSize - 10, 34),
                                ),
                              ),
                          ],
                          ...wordSpans,
                        ],
                      );
                    });
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopHeader() {
    return Positioned(
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
              (pageData[widget.pageNumber - 1][0]['start']).toString()),
        ),
      ),
    );
  }

  Widget _buildBottomFooter() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: QuranContainerDown(
          pageNumber: pageNumber,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    const buttonWidth = 200.0;
    const buttonHeight = 100.0;

    // Adjust button position to ensure it's fully visible
    final leftPosition = buttonPosition!.dx.clamp(0, screenWidth - buttonWidth);
    final topPosition =
        buttonPosition!.dy.clamp(0, screenHeight - buttonHeight);

    return Positioned(
      left: leftPosition.toDouble(),
      top: topPosition.toDouble(),
      child: VerseButtons(
        currentSurahIndex: currentSurahIndex, // Updated dynamically
        highlightedVerse: highlightedVerse!,
      ),
    );
  }
}
