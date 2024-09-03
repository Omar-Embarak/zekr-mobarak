import 'package:azkar_app/pages/quran_pages/quran_text_page.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:azkar_app/widgets/surahs_list_widget.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'book_mark_page.dart';
import 'juz_page.dart';

class QuranReadingMainPage extends StatelessWidget {
  const QuranReadingMainPage({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: AppColors.kPrimaryColor,
        appBar: AppBar(
          backgroundColor: AppColors.kSecondaryColor,
          centerTitle: true,
          title: const Text(
            "القرآن الكريم",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            TabBar(
              indicatorColor: AppColors.kSecondaryColor,
              labelColor: AppColors.kSecondaryColor,
              unselectedLabelColor: const Color.fromARGB(255, 129, 104, 95),
              labelStyle: AppStyles.styleRajdhaniBold20(context),
              tabs: const [
                Tab(text: 'سورة'),
                Tab(text: 'جزء'),
                Tab(text: 'المراجعيات'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SurahListWidget(onSurahTap: (surahIndex) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurahPage(surahIndex: surahIndex),
                      ),
                    );
                  }),
                  const JuzListPage(),
                  const BookmarksPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
