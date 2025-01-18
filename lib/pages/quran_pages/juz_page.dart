import 'package:azkar_app/constants.dart';
import 'package:azkar_app/pages/quran_pages/surah_page.dart';
import 'package:azkar_app/utils/app_images.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/quran.dart';
import '../../methods.dart';
import '../../widgets/hizp_image.dart';
import 'search_provider.dart';

class JuzListPage extends StatefulWidget {
  const JuzListPage({super.key});

  @override
  State<JuzListPage> createState() => _JuzListPageState();
}

class _JuzListPageState extends State<JuzListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final searchProvider = Provider.of<SearchProvider>(context);
    final query = normalizeArabic(searchProvider.query.trim().toLowerCase());

    // Show all Juz if the query is empty
    final filteredJuz = query.isEmpty
        ? juzData.asMap().entries.map((entry) {
            final index = entry.key;
            final juz = entry.value;
            return {
              'index': index,
              'juz': juz,
            };
          }).toList()
        : juzData.asMap().entries.map((entry) {
            final index = entry.key;
            final juz = entry.value;
            return {
              'index': index,
              'juz': juz,
            };
          }).where((entry) {
            final arbaa = entry['juz']['arbaa'] as List<dynamic>?;
            if (arbaa == null) return false;

            return arbaa.any((quarter) {
              final surahNumber = quarter['surah_number'];
              final verseNumber = quarter['verse_number'];
              if (surahNumber == null || verseNumber == null) return false;

              final verse = getVerse(surahNumber, verseNumber);
              final surahName = getSurahNameArabic(surahNumber);

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
          : filteredJuz.isEmpty && query.isNotEmpty
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
                            'الجزء ${(originalIndex + 1).toString()}',
                            textAlign: TextAlign.center,
                            style:
                                AppStyles.styleDiodrumArabicMedium15(context),
                          ),
                        ),
                        if (matchingQuarters.isNotEmpty)
                          ..._buildQuarterContainers(matchingQuarters, query),
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

  List<Widget> _buildQuarterContainers(
      List<Map<String, dynamic>> quarters, String query) {
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
        final verse = getVerse(surahNumber, verseNumber);

        containers.add(
          GestureDetector(
            onTap: () {
              Provider.of<SearchProvider>(context, listen: false)
                  .clearSearchController();
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
                  // HizbImage widget
                  HizbImage(
                    quarterImages: quarterImages,
                    index: originalIndex,
                  ),
                  const SizedBox(width: 10), // Spacing between image and text

                  // Constrained Column for Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Highlighted verse
                        _buildHighlightedVerse(verse, query, context),
                        const SizedBox(height: 8),

                        // Surah name and Ayah number
                        Row(
                          children: [
                            Text(
                              'آية: $verseNumber',
                              style: AppStyles.styleRajdhaniMedium18(context),
                            ),
                            const SizedBox(width: 16),
                            _buildHighlightedSurahName(
                                getSurahNameArabic(surahNumber),
                                query,
                                context),
                          ],
                        ),
                      ],
                    ),
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

  Widget _buildHighlightedSurahName(
      String surahName, String query, BuildContext context) {
    // Normalize both the surah name and query by removing tashkeel
    final normalizedQuery = removeTashkeel(query);
    final normalizedSurahName = removeTashkeel(surahName);

    final queryIndex = normalizedSurahName.indexOf(normalizedQuery);

    if (queryIndex != -1) {
      final start = queryIndex > 10 ? queryIndex - 10 : 0;
      final end = queryIndex + normalizedQuery.length + 10 < surahName.length
          ? queryIndex + normalizedQuery.length + 10
          : surahName.length;

      final preText = start > 0 ? '...' : '';
      final postText = end < surahName.length ? '...' : '';

      return RichText(
        text: TextSpan(
          style: AppStyles.styleRajdhaniMedium18(context),
          children: [
            if (start > 0)
              TextSpan(
                text: preText,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            TextSpan(
              text: surahName.substring(start, queryIndex),
            ),
            TextSpan(
              text: surahName.substring(
                  queryIndex, queryIndex + normalizedQuery.length),
              style: const TextStyle(
                color: Colors.red,
                backgroundColor: Colors.yellow,
              ),
            ),
            TextSpan(
              text:
                  surahName.substring(queryIndex + normalizedQuery.length, end),
            ),
            if (end < surahName.length)
              TextSpan(
                text: postText,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
          ],
        ),
      );
    } else {
      return Text(
        surahName,
        style: AppStyles.styleRajdhaniMedium18(context),
      );
    }
  }

  Widget _buildHighlightedVerse(
      String verse, String query, BuildContext context) {
    // Normalize query and verse for accurate comparison
    final normalizedQuery = removeTashkeel(query.trim());
    final normalizedVerse = removeTashkeel(verse.trim());
    final queryIndex = normalizedVerse.indexOf(normalizedQuery);
    final isSearching = Provider.of<SearchProvider>(context).isSearching;
    if (isSearching) {
      verse = removeTashkeel(verse);
    }
    // If a query matches part of the verse
    if (queryIndex != -1) {
      final start = queryIndex > 0 ? queryIndex : 0;
      final end = queryIndex + normalizedQuery.length;

      return RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis, // Ensure ellipses for overflow
        text: TextSpan(
          style: AppStyles.styleRajdhaniMedium22(context), // Base text style
          children: [
            // Text before the matched query
            TextSpan(
              text: verse.substring(0, start),
            ),
            // Highlighted matched query
            TextSpan(
              text: verse.substring(start, end),
              style: const TextStyle(
                color: Colors.red,
                backgroundColor: Colors.yellow,
              ),
            ),
            // Text after the matched query
            TextSpan(
              text: verse.substring(end),
            ),
          ],
        ),
      );
    }

    // Default: Show the verse with ellipsis if it overflows
    return Text(
      verse,
      style: AppStyles.styleRajdhaniMedium20(context),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
