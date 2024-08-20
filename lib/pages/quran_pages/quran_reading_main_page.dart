import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'package:provider/provider.dart';
import 'book_mark_page.dart';
import 'book_mark_provider.dart';
import 'juz_page.dart';
import 'surah_list_page.dart';

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: AppColors.kPrimaryColor,
          fontFamily: 'Rajdhani',
        ),
        home: const SurahListPage(),
      ),
    );
  }
}

class QuranPage extends StatelessWidget {
  const QuranPage({super.key});

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
        body: const Column(
          children: [
            TabBar(
              indicatorColor: AppColors.kSecondaryColor,
              labelColor: AppColors.kSecondaryColor,
              unselectedLabelColor: Color.fromARGB(255, 129, 104, 95),
              labelStyle: AppStyles.styleRajdhaniBold20, 
              tabs: [
                Tab(text: 'سورة'),
                Tab(text: 'جزء'),
                Tab(text: 'المراجعيات'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SurahListPage(),
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
