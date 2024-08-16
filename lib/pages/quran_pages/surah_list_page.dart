import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import '../../constants/colors.dart';
import 'quran_text_page.dart';

class SurahListPage extends StatelessWidget {
  const SurahListPage({super.key});

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
              child: Text(
                'الجزء ${index + 1}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
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
              return ListTile(
                title: Text(
                  'سورة ${quran.getSurahNameArabic(entry.key)} - $surahType',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('عدد الآيات: ${entry.value}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SurahPage(surahIndex: entry.key),
                    ),
                  );
                },
              );
            }),
          ],
        );
      },
    );
  }
}
