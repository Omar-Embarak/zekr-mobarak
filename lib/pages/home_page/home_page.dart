import 'package:flutter/material.dart';
import 'package:jhijri/jHijri.dart';

import '../../constants/colors.dart';
import '../../widgets/main_category_widget.dart';
import '../azkar_pages/azkar_main_page.dart';
import '../pray_page/pray_page.dart';
import '../quran_pages/quran_reading_main_page.dart';
import '../ruqiya_pages/ruqiya_page.dart';

class HomePages extends StatelessWidget {
  HomePages({super.key});
  final jHijri = JHijri.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.kSecondaryColor,
        centerTitle: true,
        title: const Text(
          "القائمة الرئيسية",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "${jHijri.day} ${jHijri.monthName} ${jHijri.year}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AzkarPage()));
                      },
                      child: const MainCategoryWidget(
                          width: 175,
                          categoryImg: "assets/images/azkar.png",
                          categoryTitle: "الأذكار"),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RuqiyaPage()));
                      },
                      child: const MainCategoryWidget(
                          width: 175,
                          categoryImg: "assets/images/ruqiya.png",
                          categoryTitle: "الرقية الشرعية"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ParyPage()));
                      },
                      child: const MainCategoryWidget(
                          width: 175,
                          categoryImg: "assets/images/muslim_prayer.png",
                          categoryTitle: "الصلاة"),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const QuranPage()));
                      },
                      child: const MainCategoryWidget(
                          width: 175,
                          categoryImg: "assets/images/quran.png",
                          categoryTitle: "القرآن الكريم"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                    onTap: () {},
                    child: const MainCategoryWidget(
                        width: 375,
                        categoryImg: "assets/images/chio5.jpg",
                        categoryTitle: "الشيوخ"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
