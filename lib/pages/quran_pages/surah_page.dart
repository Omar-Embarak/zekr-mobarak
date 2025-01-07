import 'dart:async';
import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/page_data.dart';
import 'package:quran/quran.dart' as quran;
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../constants.dart';
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
  final PageController _pageController = PageController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isBuffering = false;

  @override
  void initState() {
    super.initState();
    pageNumber = widget.pageNumber;
    _loadPageContent(pageNumber);
    _preloadAudio();
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
      setState(() {});
    } catch (e) {
      log("Error loading page content: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load page content: $e")),
      );
    }
  }

  void _preloadAudio() async {
    try {
      String audioUrl =
          quran.getAudioURLByVerse(currentSurahIndex, highlightedVerse ?? 1);
      await _audioPlayer.setSourceUrl(audioUrl);
    } catch (e) {
      log("Error preloading audio: $e");
    }
  }

  void _selectVerse(Offset globalPosition, [int? verseNumber]) {
    setState(() {
      highlightedVerse = verseNumber ?? 1;
      buttonPosition = globalPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => setState(() {
              isVisible = !isVisible;
              highlightedVerse = null;
            }),
            onLongPressStart: (details) => _selectVerse(details.globalPosition),
            child: SafeArea(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (newPageIndex) {
                  setState(() {
                    pageNumber = newPageIndex + 1;
                    highlightedVerse = null;
                  });
                  _loadPageContent(pageNumber);
                },
                itemBuilder: (context, index) {
                  return _buildPageContent();
                },
              ),
            ),
          ),
          if (isVisible) _buildTopHeader(),
          if (isVisible) _buildBottomFooter(),
          if (highlightedVerse != null && buttonPosition != null)
            _buildActionButtons(),
          if (isBuffering) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildPageContent() {
    return Consumer<QuranFontSizeProvider>(
      builder: (context, fontSizeProvider, child) {
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(right: 8),
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    style: AppStyles.styleAmiriMedium30(context)
                        .copyWith(fontSize: fontSizeProvider.fontSize),
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
                                      highlightedVerse = verseIndex;
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
          ],
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
