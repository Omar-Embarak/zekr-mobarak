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
        // Sets the theme for the icons in the AppBar (e.g., the leading icon)
        iconTheme: IconThemeData(
          color: AppStyles.styleCairoMedium15white(context).color,
        ),
        backgroundColor: AppColors.kSecondaryColor,
        centerTitle: true,
        title: Text(
          "القائمة الرئيسية",
          style: AppStyles.styleCairoBold20(context),
        ),
        // Leading widget: Theme icon that shows a menu to change app themes
        leading: IconButton(
          onPressed: () {
            // Get the overlay to position the menu relative to the screen
            final RenderBox overlay =
                Overlay.of(context).context.findRenderObject() as RenderBox;
            // Access the ThemeCubit for theme changes
            final themeCubit = context.read<ThemeCubit>();

            // Show the popup menu for theme selection
            showMenu(
              color: AppColors.kSecondaryColor,
              context: context,
              position: RelativeRect.fromRect(
                Rect.fromLTWH(
                  overlay.size.width - 50, // Horizontal position of the menu
                  50, // Vertical position of the menu
                  50,
                  50,
                ),
                Offset.zero & overlay.size,
              ),
              items: [
                PopupMenuItem(
                  onTap: () {
                    themeCubit.setTheme(lightTheme);
                    setState(() {});
                  },
                  child: Text(
                    'الوضع الفاتح',
                    style: AppStyles.styleCairoMedium15white(context),
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    themeCubit.setTheme(darkTheme);
                    setState(() {});
                  },
                  child: Text(
                    'الوضع المظلم',
                    style: AppStyles.styleCairoMedium15white(context),
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    themeCubit.setTheme(defaultTheme);
                    setState(() {});
                  },
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
          ),
        ),
        // Actions: Right-side icons in the AppBar (used here for the info icon)
        actions: [
          IconButton(
            onPressed: () {
              // Show an AlertDialog with information when the info icon is pressed
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColors.kSecondaryColor,
                  title: Text(
                    "اهداء",
                    style: TextStyle(
                      color: AppStyles.styleCairoBold20(context).color,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign:
                        TextAlign.center, // Centers text within the Text widget
                  ),
                  content: SingleChildScrollView(
                    // Wrap the Text in Center to ensure overall centering in the dialog
                    child: Center(
                      child: Text(
                        '''
اللهم اجعله خالصا لوجهك الكريم وانفع به المسلمين واجز كل من ساهم فيه وفي نشره خيرا

صدقة جارية عن أبي امبارك ورداني رحمه الله وأمواتنا واموات المسلمين أجمعين وعن امي واخواتي وأبنائهم وازواجهم وزوجتي واولادي وأهلي جميعا وعن المسلمين أجمعين

للتواصل مع المطور: oesam7797@gmail.com
          '''
                            .trim(), // .trim() removes extra newlines and spaces from the start and end
                        style: TextStyle(
                          color: AppStyles.styleCairoBold20(context).color,
                          fontFamily: "Amiri",
                        ),
                        textAlign: TextAlign
                            .center, // This centers text content within the Text widget
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Close the dialog when the button is pressed
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "امين",
                        style: TextStyle(
                          color: AppStyles.styleCairoBold20(context).color,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.info_outline,
            ),
          ),
        ],
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
