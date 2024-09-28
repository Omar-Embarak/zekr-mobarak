import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jhijri/jHijri.dart';
import '../../constants.dart';
import '../../widgets/bottom_sheet.dart';
import '../../widgets/main_category_widget.dart';
import '../azkar_pages/azkar_main_page.dart';
import '../chio5_pages/chio5_page.dart';
import '../pray_page/pray_page.dart';
import '../ruqiya_pages/ruqiya_page.dart';

class HomePages extends StatelessWidget {
  HomePages({super.key});
  final jHijri = JHijri.now();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const AzkarPage()));
                          },
                          child: MainCategoryWidget(
                            categoryImg: "assets/images/azkar.png",
                            categoryTitle: "الأذكار",
                            width: screenWidth / 2 - 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const RuqiyaPage()));
                          },
                          child: MainCategoryWidget(
                            categoryImg: "assets/images/ruqiya.png",
                            categoryTitle: "الرقية الشرعية",
                            width: screenWidth / 2 - 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ParyPage()));
                          },
                          child: MainCategoryWidget(
                            categoryImg: "assets/images/muslim_prayer.png",
                            categoryTitle: "الصلاة",
                            width: screenWidth / 2 - 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            modalBottomSheet(context);
                          },
                          child: MainCategoryWidget(
                            categoryImg: "assets/images/quran.png",
                            categoryTitle: "القرآن الكريم",
                            width: screenWidth / 2 - 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const DroosPage()));
                    },
                    child: MainCategoryWidget(
                      width: screenWidth,
                      categoryImg: "assets/images/chio5.jpg",
                      categoryTitle: "دروس دينية",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
