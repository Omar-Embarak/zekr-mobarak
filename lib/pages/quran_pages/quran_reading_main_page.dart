import 'package:azkar_app/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_style.dart';
import '../../widgets/surahs_list_widget.dart';
import '../../constants.dart';
import 'book_mark_page.dart';
import 'juz_page.dart';
import 'quran_font_size_provider.dart';
import 'search_provider.dart';

class QuranReadingMainPage extends StatefulWidget {
  const QuranReadingMainPage({super.key});

  @override
  State<QuranReadingMainPage> createState() => _QuranReadingMainPageState();
}

class _QuranReadingMainPageState extends State<QuranReadingMainPage> {
  bool _isSearching = false;
  void _filterPageContent(String query) {
    // Notify SurahListWidget about the query change
    setState(() {
      Provider.of<SearchProvider>(context, listen: false).updateQuery(query);
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      Provider.of<SearchProvider>(context, listen: false).toogleSearch(
        _isSearching,
      );

      if (!_isSearching) {
        Provider.of<SearchProvider>(context, listen: false)
            .clearSearchController();
        _filterPageContent('');
      }
    });
  }

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
          appBar: AppBar(  iconTheme: IconThemeData(
            color: AppStyles.styleCairoMedium15white(context).color),
            backgroundColor: AppColors.kSecondaryColor,
            centerTitle: true,
            title: _isSearching
                ? TextField(
                    controller:
                        Provider.of<SearchProvider>(context, listen: false)
                            .searchController(),
                    onChanged: _filterPageContent,
                    style: AppStyles.styleCairoMedium15white(context),
                    decoration: InputDecoration(
                      hintText: 'البحث...',
                      hintStyle: AppStyles.styleCairoMedium15white(context),
                      border: InputBorder.none,
                    ),
                    autofocus: true,
                  )
                : Text(
                    'القران الكريم',
                    style: AppStyles.styleCairoBold20(context),
                  ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: _toggleSearch,
                                child: Icon(_isSearching ? Icons.close : Icons.search),

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
                    .withOpacity(0.6),
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
