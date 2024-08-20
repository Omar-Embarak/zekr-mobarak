import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import '../../constants/colors.dart';
import 'quran_text_page.dart';

class SurahListPage extends StatelessWidget {
  const SurahListPage({super.key});
  final List<String> arabicOrdinals = const [
    'الاول',
    'الثاني',
    'الثالث',
    'الرابع',
    'الخامس',
    'السادس',
    'السابع',
    'الثامن',
    'التاسع',
    'العاشر',
    'الحادي عشر',
    'الثاني عشر',
    'الثالث عشر',
    'الرابع عشر',
    'الخامس عشر',
    'السادس عشر',
    'السابع عشر',
    'الثامن عشر',
    'التاسع عشر',
    'العشرون',
    'الحادي والعشرون',
    'الثاني والعشرون',
    'الثالث والعشرون',
    'الرابع والعشرون',
    'الخامس والعشرون',
    'السادس والعشرون',
    'السابع والعشرون',
    'الثامن والعشرون',
    'التاسع والعشرون',
    'الثلاثون',
  ];

  @override
  Widget build(BuildContext context) {
    final shownSurahs = <int>{}; // مجموعة لتتبع السور التي تم عرضها

    return ListView.builder(
      itemCount: quran.totalJuzCount,
      itemBuilder: (context, index) {
        final surahsInJuz = quran.getSurahAndVersesFromJuz(index + 1);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 41,
              width: double.infinity,
              decoration: const BoxDecoration(color: AppColors.kSecondaryColor),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Text('الجزء ${arabicOrdinals[index]}',
                      style: AppStyles.styleRajdhaniMedium18
                          .copyWith(color: Colors.white)),
                  const Spacer(),
                  Text(
                    '1',
                    style: AppStyles.styleRajdhaniMedium18
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            ...surahsInJuz.entries.where((entry) {
              // نعرض السورة فقط إذا لم تكن قد ظهرت من قبل
              if (shownSurahs.contains(entry.key)) {
                return false;
              } else {
                shownSurahs.add(entry.key);
                return true;
              }
            }).map((entry) {
              final surahType =
                  quran.getPlaceOfRevelation(entry.key) == "Makkah"
                      ? "مكية"
                      : "مدنية";
              return Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Text('1', style: AppStyles.styleRajdhaniMedium18),
                  Expanded(
                    child: ListTile(
                      trailing: const Text(
                        '1',
                        style: AppStyles.styleRajdhaniBold13,
                      ),
                      title: Text(
                          'سورة ${quran.getSurahNameArabic(entry.key)} ',
                          style: AppStyles.styleRajdhaniMedium18),
                      subtitle: Row(
                        children: [
                          Text(' $surahType - ${entry.value} اية ',
                              style: AppStyles.styleRajdhaniBold13
                                  .copyWith(color: Colors.white)),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SurahPage(surahIndex: entry.key),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ],
        );
      },
    );
  }
}
