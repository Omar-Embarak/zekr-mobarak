import 'package:azkar_app/pages/home_page/home_page.dart';
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
            backgroundColor: AppColors.kSecondaryColor,
            centerTitle: true,
            title: Text(
              "القرآن الكريم",
              style: AppStyles.styleCairoBold20(context),
            ),
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
                unselectedLabelColor:
                    AppStyles.styleCairoBold20(context).color!.withOpacity(0.5),
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
      ),
    );
  }
}
