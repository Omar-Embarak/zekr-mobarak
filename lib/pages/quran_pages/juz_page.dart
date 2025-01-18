import 'package:azkar_app/constants.dart';
import 'package:azkar_app/pages/quran_pages/surah_page.dart';
import 'package:azkar_app/utils/app_images.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/quran.dart';
import '../../methods.dart';
import 'search_provider.dart';

class JuzListPage extends StatefulWidget {
  const JuzListPage({super.key});

  @override
  State<JuzListPage> createState() => _JuzListPageState();
}

class _JuzListPageState extends State<JuzListPage> {
  List<dynamic> juzData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await loadJSONDataList('assets/quranjson/juz.json');
    setState(() {
      juzData = data;
    });
  }

  String removeTashkeel(String text) {
    const tashkeelRegex = '[\u064B-\u065F\u06D6-\u06ED]';
    return text.replaceAll(RegExp(tashkeelRegex), '');
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);
    final query = normalizeArabic(searchProvider.query.trim().toLowerCase());

    // Filter data and keep track of original index
    final filteredJuz = juzData.asMap().entries.map((entry) {
      final index = entry.key;
      final juz = entry.value;
      return {
        'index': index, // Preserve original index
        'juz': juz,
      };
    }).where((entry) {
      final arbaa = entry['juz']['arbaa'] as List<dynamic>?;
      if (arbaa == null || query.isEmpty) return false;

      return arbaa.any((quarter) {
        final surahNumber = quarter['surah_number'];
        final verseNumber = quarter['verse_number'];
        if (surahNumber == null || verseNumber == null) return false;

        final verse =
            normalizeArabic(getVerse(surahNumber, verseNumber)).trim();
        final surahName =
            normalizeArabic(getSurahNameArabic(surahNumber)).trim();

        final normalizedQuery = removeTashkeel(query);
        final normalizedVerse = removeTashkeel(verse);
        final normalizedSurahName = removeTashkeel(surahName);

        return normalizedVerse.contains(normalizedQuery) ||
            normalizedSurahName.contains(normalizedQuery);
      });
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      body: juzData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : filteredJuz.isEmpty
              ? const Center(child: Text("No results found"))
              : ListView.builder(
                  itemCount: filteredJuz.length,
                  itemBuilder: (context, index) {
                    final originalIndex = filteredJuz[index]['index'];
                    final juz = filteredJuz[index]['juz'];
                    final matchingQuarters =
                        _filterMatchingQuarters(juz['arbaa'], query);

                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.kSecondaryColor,
                            border: const Border(
                              bottom: BorderSide(color: Colors.grey),
                            ),
                          ),
                          child: Text(
                            'الجزء ${(originalIndex + 1).toString()}', // Display correct Juz number
                            textAlign: TextAlign.center,
                            style:
                                AppStyles.styleDiodrumArabicMedium15(context),
                          ),
                        ),
                        if (matchingQuarters.isNotEmpty)
                          ..._buildQuarterContainers(matchingQuarters),
                      ],
                    );
                  },
                ),
    );
  }

  List<Map<String, dynamic>> _filterMatchingQuarters(
      List<dynamic>? quarters, String query) {
    if (quarters == null) return [];

    return quarters.asMap().entries.map((entry) {
      final index = entry.key;
      final quarter = entry.value;
      return {
        'index': index,
        'quarter': quarter,
      };
    }).where((entry) {
      final quarter = entry['quarter'];
      final surahNumber = quarter['surah_number'];
      final verseNumber = quarter['verse_number'];
      if (surahNumber == null || verseNumber == null) return false;

      final verse = normalizeArabic(getVerse(surahNumber, verseNumber)).trim();
      final surahName = normalizeArabic(getSurahNameArabic(surahNumber)).trim();

      final normalizedQuery = removeTashkeel(query);
      final normalizedVerse = removeTashkeel(verse);
      final normalizedSurahName = removeTashkeel(surahName);

      return normalizedVerse.contains(normalizedQuery) ||
          normalizedSurahName.contains(normalizedQuery);
    }).toList();
  }

  List<Widget> _buildQuarterContainers(List<Map<String, dynamic>> quarters) {
    List<Widget> containers = [];
    List<String> quarterImages = [
      Assets.imagesHizp,
      Assets.imagesRob3,
      Assets.imagesHalf,
      Assets.images3rob3,
    ];

    for (var entry in quarters) {
      final originalIndex = entry['index'];
      final quarter = entry['quarter'];
      if (quarter != null) {
        final surahNumber = quarter['surah_number'];
        final verseNumber = quarter['verse_number'];

        containers.add(
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SurahPage(
                    pageNumber: getPageNumber(surahNumber, verseNumber),
                  ),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: const Border(
                  bottom: BorderSide(color: Colors.grey),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  HizbImage(
                    quarterImages: quarterImages,
                    index: originalIndex,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${getVerse(surahNumber, verseNumber).length > 30 ? getVerse(surahNumber, verseNumber).substring(0, 30) : getVerse(surahNumber, verseNumber)}...",
                        style: AppStyles.styleRajdhaniMedium20(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'آية: $verseNumber',
                            style: AppStyles.styleRajdhaniMedium18(context),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            getSurahNameArabic(surahNumber),
                            style: AppStyles.styleRajdhaniBold18(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    return containers;
  }
}

class HizbImage extends StatelessWidget {
  const HizbImage({
    super.key,
    required this.quarterImages,
    required this.index,
  });

  final List<String> quarterImages;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Stack(
        children: [
          Image.asset(
            quarterImages[index % quarterImages.length],
            fit: BoxFit.cover,
          ),
          Center(
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
