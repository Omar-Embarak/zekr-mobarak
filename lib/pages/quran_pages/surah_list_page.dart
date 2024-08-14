
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

import '../../constants/colors.dart';
import 'quran_reading_main_page.dart';
import 'quran_text_page.dart';

class SurahListPage extends StatelessWidget {
  const SurahListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: quran.totalJuzCount, // عرض السور مجمعة حسب الجزء
      itemBuilder: (context, index) {
        final surahsInJuz = quran.getSurahAndVersesFromJuz(index + 1);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: AppColors.kSecondaryColor),
              child: Text('جزء ${index + 1}'),
            ),
            ...surahsInJuz.entries.map((entry) {
              return ListTile(
                title: Text(
                  quran.getSurahNameArabic(entry.key),
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
            }).toList(),
          ],
        );
      },
    );
  }
}