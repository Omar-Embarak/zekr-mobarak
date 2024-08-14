
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'quran_text_page.dart';

class JuzListPage extends StatelessWidget {
  const JuzListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: quran.totalJuzCount,
      itemBuilder: (context, index) {
        final surahsInJuz = quran.getSurahAndVersesFromJuz(index + 1);
        return ExpansionTile(
          title: Text('جزء ${index + 1}'),
          children: surahsInJuz.entries.map((entry) {
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
        );
      },
    );
  }
}
