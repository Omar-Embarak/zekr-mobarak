import 'package:azkar_app/methods.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jhijri/jHijri.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../cubit/theme_cubit/theme_cubit.dart';
import '../../widgets/bottom_sheet.dart';
import '../../widgets/dedicated_button.dart';
import '../../widgets/main_category_widget.dart';
import '../azkar_pages/azkar_main_page.dart';
import '../azkar_pages/notification_service.dart';
import '../islamic_lessons_pages/islamic_lessons_page.dart';
import '../pray_page/pray_page.dart';
import '../ruqiya_pages/ruqiya_page.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  final jHijri = JHijri.now();

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppStyles.styleCairoMedium15white(context).color,
        ),
        backgroundColor: AppColors.kSecondaryColor,
        centerTitle: true,
        title: Text(
          "القائمة الرئيسية",
          style: AppStyles.styleDiodrumArabicbold20(context),
        ),
        // Leading button to open the left Drawer
        leading: buildThemeButton(
            context), // Two action buttons: notifications toggle & info dialog
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                // _notificationsEnabled = !_notificationsEnabled;
              });
            },
            icon: IconButton(
              icon: Icon(
                NotificationService.isNotificationsEnabled()
                    ? Icons.notifications
                    : Icons.notifications_off,
              ),
              onPressed: () async {
                if (NotificationService.isNotificationsEnabled()) {
                  await NotificationService.disableNotifications();
                  showMessage("تم ايقاف تشغيل الاشعارات");
                } else {
                  await NotificationService.enableNotifications();
                  showMessage("الاشعارات مفعلة");
                }
                setState(() {}); // Refresh UI after toggling
              },
              color: AppStyles.styleCairoMedium15white(context).color,
            ),
          ),
          const DedicationButton(),
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
                          builder: (context) =>
                              const MainIslamicLessonsPage()));
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

  IconButton buildThemeButton(BuildContext context) {
    return IconButton(
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
    );
  }
}
