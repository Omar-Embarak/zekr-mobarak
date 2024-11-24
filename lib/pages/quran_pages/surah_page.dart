import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:quran/page_data.dart';
import 'package:quran/quran.dart' as quran;
import '../../constants.dart';
import '../../widgets/quran_container_down.dart';
import '../../widgets/quran_container_up.dart';
import '../../widgets/surah_border.dart';
import '../../widgets/verse_buttons_widget.dart';
import 'quran_reading_main_page.dart';

class SurahPage extends StatefulWidget {
  final int pageNumber;

  const SurahPage({super.key, required this.pageNumber});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  bool isVisible = true; // Toggle visibility for UI components
  Map<int, List<Map<String, dynamic>>> pageContent =
      {}; // Stores verses for the current page
  int currentSurahIndex = 0; // Current Surah
  int currentJuzNumber = 0; // Current Juz
  int? highlightedVerse; // Highlighted verse number
  Offset? buttonPosition; // Position for the action buttons
  late int pageNumber;
  @override
  void initState() {
    super.initState();
    pageNumber = widget.pageNumber;
    _loadPageContent(pageNumber);
  }

  /// Loads content for the specified page number
  Future<void> _loadPageContent(int pageNumber) async {
    try {
      // Clear previous content
      pageContent.clear();

      // Get data for the current page
      List<Map<String, dynamic>> currentPageData = pageData[pageNumber - 1];

      for (var entry in currentPageData) {
        int surahNumber = entry['surah'];
        int startVerse = entry['start'];
        int endVerse = entry['end'];

        currentSurahIndex = surahNumber;
        currentJuzNumber = quran.getJuzNumber(surahNumber, startVerse);

        // Collect all verses for the Surah on this page
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
      log("Error loading page content: $e");
    }
  }

  /// Handles the selection of a verse
  void _selectVerse(Offset globalPosition, [int? verseNumber]) {
    setState(() {
      highlightedVerse = verseNumber ?? 1; // Set highlighted verse
      buttonPosition = globalPosition; // Save button position
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        // Navigate to QuranReadingMainPage
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const QuranReadingMainPage()),
          (route) => false, // Clear all previous routes
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.kPrimaryColor,
        body: Stack(
          children: [
            // Main Quran Page Content
            GestureDetector(
              onTap: () => setState(() {
                isVisible = !isVisible; // Toggle UI visibility
                highlightedVerse = null; // Clear highlighted verse
              }),
              onLongPressStart: (details) =>
                  _selectVerse(details.globalPosition),
              child: SafeArea(
                child: PageView.builder(
                  controller: PageController(initialPage: pageNumber - 1),
                  onPageChanged: (newPageIndex) {
                    setState(() {
                      pageNumber = newPageIndex + 1; // Update page number
                      highlightedVerse = null; // Clear highlights
                    });
                    _loadPageContent(pageNumber); // Reload content
                  },
                  itemBuilder: (context, index) {
                    return _buildPageContent();
                  },
                ),
              ),
            ),

            // Top Header Container
            if (isVisible) _buildTopHeader(),

            // Bottom Navigation Container
            if (isVisible) _buildBottomFooter(),

            // Action Buttons for Highlighted Verse
            if (highlightedVerse != null && buttonPosition != null)
              _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  /// Builds the Quranic content for the page
  Widget _buildPageContent() {
    return GestureDetector(
      onDoubleTapDown: (details) => _selectVerse(details.globalPosition),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(right: 8),
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
              style: AppStyles.styleAmiriMedium30(context),
              children: pageContent.entries.expand((entry) {
                int surahNumber = entry.key;
                return entry.value.map((verseEntry) {
                  int verseIndex = verseEntry['verseNumber'];
                  String verseText = verseEntry['verseText'];
                  bool isHighlighted = highlightedVerse == verseIndex;

                  return TextSpan(
                    children: [
                      if (verseIndex == 1)
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: SurahBorder(surahNumber: surahNumber),
                        ),
                      TextSpan(
                        text:
                            ' $verseText${quran.getVerseEndSymbol(verseIndex, arabicNumeral: true)} ',
                        style: TextStyle(
                          backgroundColor: isHighlighted
                              ? Colors.yellow.withOpacity(0.4)
                              : Colors.transparent,
                          color: isHighlighted ? Colors.red : null,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => setState(() {
                                highlightedVerse =
                                    verseIndex; // Highlight verse
                              }),
                      ),
                    ],
                  );
                });
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the top header container
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

  /// Builds the bottom footer container
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

  /// Builds the action buttons for the highlighted verse
  Widget _buildActionButtons() {
    return Positioned(
      left:
          buttonPosition!.dx.clamp(0, MediaQuery.of(context).size.width - 150),
      top: buttonPosition!.dy.clamp(0, MediaQuery.of(context).size.height - 50),
      child: VerseButtons(
        currentSurahIndex: currentSurahIndex,
        highlightedVerse: highlightedVerse!,
      ),
    );
  }
}
