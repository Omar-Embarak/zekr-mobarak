import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/quran.dart' as quran;
import '../pages/quran_pages/search_provider.dart';
import '../utils/app_style.dart';
import '../constants.dart';
import '../pages/quran_pages/surah_page.dart';

class SurahListWidget extends StatefulWidget {
  const SurahListWidget({super.key});

  @override
  State<SurahListWidget> createState() => _SurahListWidgetState();
}

class _SurahListWidgetState extends State<SurahListWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Call this to ensure keep-alive works

    final searchProvider = Provider.of<SearchProvider>(context);
    final query = searchProvider.query.trim().toLowerCase();

    // Filter Surahs based on the query
    final filteredSurahs =
        List.generate(quran.totalSurahCount, (index) => index + 1)
            .where((surahNumber) =>
                query.isEmpty ||
                quran.getSurahNameArabic(surahNumber).contains(query) ||
                quran.getSurahName(surahNumber).toLowerCase().contains(query))
            .toList();

    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      body: ListView.builder(
        key: const PageStorageKey('surahList'), // Retains scroll position
        itemCount: filteredSurahs.length,
        itemBuilder: (context, index) {
          final surahNumber = filteredSurahs[index];
          final surahsInJuz = quran.getSurahAndVersesFromJuz(
            quran.getJuzNumber(surahNumber, 1),
          );
          return _buildJuzSection(context, quran.getJuzNumber(surahNumber, 1),
              surahsInJuz, surahNumber);
        },
      ),
    );
  }

  Widget _buildJuzSection(BuildContext context, int juzIndex,
      Map<int, List<int>> surahsInJuz, int surahNumber) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildJuzHeader(context, juzIndex),
        _buildSurahRow(context,
            MapEntry(surahNumber, surahsInJuz[surahNumber] ?? []), juzIndex),
      ],
    );
  }

  Widget _buildSurahRow(
      BuildContext context, MapEntry<int, List<int>> entry, int juzIndex) {
    final surahType =
        quran.getPlaceOfRevelation(entry.key) == "Makkah" ? "مكية" : "مدنية";

    // Fetching the actual page where each Surah starts
    final firstVersePage = quran.getSurahPages(entry.key).first;

    return Row(
      children: [
        const SizedBox(width: 10),
        Text(
          '${entry.key}', // Surah number
          style: AppStyles.styleRajdhaniMedium18(context),
        ),
        Expanded(
          child: ListTile(
            trailing: Text(
              '$firstVersePage', // Display the first page of the Surah
              style: AppStyles.styleRajdhaniBold13(context),
            ),
            title: Text(
              'سورة ${quran.getSurahNameArabic(entry.key)}',
              style: AppStyles.styleRajdhaniMedium18(context),
            ),
            subtitle: Row(
              children: [
                Text(
                  '$surahType - ${surahsAyat[entry.key - 1]['count']} اية',
                  style: AppStyles.styleRajdhaniBold13(context)
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
            onTap: () => _navigateToSurahPage(context, firstVersePage),
          ),
        ),
      ],
    );
  }

  Widget _buildJuzHeader(BuildContext context, int index) {
    return Container(
      height: 41,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.kSecondaryColor,
        gradient: LinearGradient(
          colors: [AppColors.kSecondaryColor, AppColors.kPrimaryColor],
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Text(
            'الجزء ${arabicOrdinals[index - 1]}',
            style: AppStyles.styleDiodrumArabicMedium15(context),
          ),
          const Spacer(),
          Text(
            '${quran.getSurahPages(index).first}', // Page number where each Juz starts
            style: AppStyles.styleRajdhaniMedium18(context)
                .copyWith(color: Colors.white),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  void _navigateToSurahPage(BuildContext context, int firstVersePage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurahPage(
          pageNumber: firstVersePage,
        ),
      ),
    );
  }
}
