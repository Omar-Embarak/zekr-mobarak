import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import '../../constants/colors.dart';

class SurahPage extends StatelessWidget {
  const SurahPage({super.key, required this.surahIndex});
  final int surahIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(8),
        height: 91,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.kSecondaryColor.withOpacity(0.87),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Row(
                  children: [
                    Text('الجزء 3'),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${quran.getSurahNameArabic(surahIndex)} (مكية ،اياتها 286)',
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 67,
                  width: 67,
                  child: Image.asset('assets/images/right_page.png'),
                ),
                const Text(
                  '1/4 لحزب 5',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
