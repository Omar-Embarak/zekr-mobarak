import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jhijri/jHijri.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../cubit/theme_cubit/theme_cubit.dart';
import '../../widgets/bottom_sheet.dart';
import '../../widgets/main_category_widget.dart';
import '../azkar_pages/azkar_main_page.dart';
import '../azkar_pages/notification_service.dart';
import '../droos_pages/droos_page.dart';
import '../pray_page/pray_page.dart';
import '../ruqiya_pages/ruqiya_page.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
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
          onPressed: () {
            final RenderBox overlay =
                Overlay.of(context).context.findRenderObject() as RenderBox;
            final themeCubit = context.read<ThemeCubit>();

            showMenu(
              color: AppColors.kSecondaryColor,
              context: context,
              position: RelativeRect.fromRect(
                Rect.fromLTWH(
                  overlay.size.width - 50, // مكان ظهور القائمة
                  50, // ارتفاع القائمة
                  50,
                  50,
                ),
                Offset.zero & overlay.size,
              ),
              items: [
                PopupMenuItem(
                  onTap: () =>
                      {themeCubit.setTheme(lightTheme), setState(() {})},
                  child: Text(
                    'الوضع الفاتح',
                    style: AppStyles.styleCairoMedium15white(context),
                  ),
                ),
                PopupMenuItem(
                  onTap: () =>
                      {themeCubit.setTheme(darkTheme), setState(() {})},
                  child: Text(
                    'الوضع المظلم',
                    style: AppStyles.styleCairoMedium15white(context),
                  ),
                ),
                PopupMenuItem(
                  onTap: () =>
                      {themeCubit.setTheme(defaultTheme), setState(() {})},
                  child: Text(
                    'الوضع الافتراضي',
                    style: AppStyles.styleCairoMedium15white(context),
                  ),
                ),
              ],
            );
          },
          icon: const Icon(
            Icons.light_mode,
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
                style: AppStyles.styleRajdhaniMedium20(context),
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
                          onTap: () async {
                            await NotificationService.showTestNotification();

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const AzkarPage()));
                          },
                          child: MainCategoryWidget(
                            categoryImg: "assets/images/azkar.png",
                            categoryTitle: "الأذكار",
                            width: screenWidth / 2 - 20 > 0
                                ? screenWidth / 2 - 20
                                : 0,
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
                            width: screenWidth / 2 - 20 > 0
                                ? screenWidth / 2 - 20
                                : 0,
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
                                builder: (context) => const PrayPage()));
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
