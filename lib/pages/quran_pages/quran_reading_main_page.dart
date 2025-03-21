import 'package:azkar_app/pages/home_page/home_page.dart';
import 'package:azkar_app/pages/quran_pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_style.dart';
import '../../widgets/surahs_list_widget.dart';
import '../../constants.dart';
import 'book_mark_page.dart';
import 'juz_page.dart';
import 'quran_font_size_provider.dart';

class QuranReadingMainPage extends StatefulWidget {
  const QuranReadingMainPage({super.key});

  @override
  State<QuranReadingMainPage> createState() => _QuranReadingMainPageState();
}

class _QuranReadingMainPageState extends State<QuranReadingMainPage> {
  @override
  Widget build(BuildContext context) {
    final fontSizeProvider =
        Provider.of<QuranFontSizeProvider>(context, listen: true);
    fontSizeProvider.loadFontSize();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        // Navigate to QuranReadingMainPage
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePages()),
          (route) => false, // Clear all previous routes
        );
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: AppColors.kPrimaryColor,
          appBar: AppBar(
            iconTheme: IconThemeData(
                color: AppStyles.styleCairoMedium15white(context).color),
            backgroundColor: AppColors.kSecondaryColor,
            centerTitle: true,
            title: Text(
              'القران الكريم',
              style: AppStyles.styleDiodrumArabicbold20(context),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SearchPage(),
                    ),
                  ),
                  child: const Icon(Icons.search),
                ),
              )
            ],
          ),
          body: Column(
            children: [
              TabBar(
                indicatorColor: AppColors.kSecondaryColor,
                labelColor: AppStyles.themeNotifier.value == defaultTheme
                    ? AppColors.kSecondaryColor
                    : (AppStyles.themeNotifier.value == lightTheme
                        ? Colors.black
                        : Colors.white),
                unselectedLabelColor: AppStyles.styleRajdhaniBold20(context)
                    .color!
                    .withAlpha((0.6 * 255).round()),
                labelStyle: AppStyles.styleRajdhaniBold20(context),
                tabs: const [
                  Tab(text: 'سورة'),
                  Tab(text: 'جزء'),
                  Tab(text: 'العلامات'),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  physics: BouncingScrollPhysics(), // Smooth scrolling

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
      ),
    );
  }
}
