import 'package:azkar_app/constants.dart';
import 'package:azkar_app/pages/quran_pages/surah_page.dart';
import 'package:azkar_app/utils/app_images.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart';
import '../../methods.dart';

// Show quarters' hizb with the first verse
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      body: juzData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: juzData.length,
              itemBuilder: (context, index) {
                final juz = juzData[index];
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.kSecondaryColor,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Text(
                        'الجزء ${arabicOrdinals[index]}',
                        textAlign: TextAlign.center,
                        style: AppStyles.styleRajdhaniBold13(context)
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    if (juz["arbaa"] != null)
                      ..._buildQuarterContainers(juz["arbaa"]),
                  ],
                );
              },
            ),
    );
  }

  List<Widget> _buildQuarterContainers(List<dynamic> quarters) {
    List<Widget> containers = [];
    List<String> quarterImages = [
      Assets.imagesHizp,
      Assets.imagesRob3,
      Assets.imagesHalf,
      Assets.images3rob3,
    ];

    for (int i = 0; i < quarters.length; i++) {
      final quarter = quarters[i];
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
                    index: i,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${getVerse(surahNumber, verseNumber).length > 30 ? getVerse(surahNumber, verseNumber).substring(0, 30) : getVerse(surahNumber, verseNumber)}...",
                        style: AppStyles.styleAmiriMedium20(context),
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

int getSurahNumberByName(String surahName) {
  for (int i = 1; i <= 114; i++) {
    if (getSurahNameArabic(i) == surahName) {
      return i;
    }
  }
  throw Exception('Surah not found: $surahName');
}
