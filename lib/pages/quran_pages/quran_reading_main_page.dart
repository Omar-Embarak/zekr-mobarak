import 'package:flutter/material.dart';
import '../../utils/app_style.dart';
import '../../widgets/surahs_list_widget.dart';
import '../../constants.dart';
import 'book_mark_page.dart';
import 'juz_page.dart';

class QuranReadingMainPage extends StatelessWidget {
  const QuranReadingMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
            const Expanded(
              child: TabBarView(
                children: [
                  SurahListWidget(),
                  JuzListPage(),
                  BookmarksPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
