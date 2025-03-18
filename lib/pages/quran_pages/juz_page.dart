import 'package:azkar_app/constants.dart';
import 'package:azkar_app/pages/quran_pages/surah_page.dart';
import 'package:azkar_app/utils/app_images.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart';
import '../../methods.dart';
import '../../widgets/hizp_image.dart';

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

  // Load the juz data from JSON
  Future<void> _loadData() async {
    final data = await loadJSONDataList('assets/quranjson/juz.json');
    setState(() {
      juzData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Map all juz data without filtering
    final allJuz = juzData.asMap().entries.map((entry) {
      final index = entry.key;
      final juz = entry.value;
      return {
        'index': index,
        'juz': juz,
      };
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      body: juzData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: allJuz.length,
              itemBuilder: (context, index) {
                final originalIndex = allJuz[index]['index'];
                final juz = allJuz[index]['juz'];
                // Always show all quarters
                final quarters = _getAllQuarters(juz['arbaa']);

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
                        style: AppStyles.styleDiodrumArabicMedium15(context),
                      ),
                    ),
                    ..._buildQuarterContainers(quarters),
                  ],
                );
              },
            ),
    );
  }

  // Simply map the quarters without filtering based on a query.
  List<Map<String, dynamic>> _getAllQuarters(List<dynamic>? quarters) {
    if (quarters == null) return [];
    return quarters.asMap().entries.map((entry) {
      final index = entry.key;
      final quarter = entry.value;
      return {
        'index': index,
        'quarter': quarter,
      };
    }).toList();
  }

  // Build UI for each quarter container.
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
        final verse = getVerse(surahNumber, verseNumber);

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
                  // HizbImage widget to show quarter image
                  HizbImage(
                    quarterImages: quarterImages,
                    index: originalIndex,
                  ),
                  const SizedBox(width: 10),
                  // Column for displaying verse and surah name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display verse without any highlight
                        Text(
                          verse,
                          style: AppStyles.styleUthmanicMedium30(context),
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
                              style: AppStyles.styleRajdhaniMedium18(context),
                            ),
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
}
