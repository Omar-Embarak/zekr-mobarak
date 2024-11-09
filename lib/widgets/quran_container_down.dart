import 'package:azkar_app/widgets/icon_constrain_widget.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../pages/quran_pages/doaa_khatm_page.dart';
import '../pages/quran_pages/juz_page.dart';
import '../utils/app_images.dart';
import '../utils/app_style.dart';
import 'quran_containers_buttons_widget.dart';
import 'surahs_list_widget.dart';

class QuranContainerDown extends StatefulWidget {
  QuranContainerDown({super.key, required this.pageNumber});
  int pageNumber;

  @override
  State<QuranContainerDown> createState() => _QuranContainerDownState();
}

class _QuranContainerDownState extends State<QuranContainerDown> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      height: 136,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.kSecondaryColor.withOpacity(0.87),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Flexible(
                flex: 3,
                child: SizedBox(
                  height: 35,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText:
                          'إبحث عن آية', //this field for search for any aya in the quran , the keyboard should push the container up
                      hintStyle: AppStyles.styleDiodrumArabicMedium15(context)
                          .copyWith(color: Colors.white),
                      suffixIcon: const IconConstrain(
                          height: 26, imagePath: Assets.imagesSearch),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: const Color(0x66CFAD65),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  height: 35,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        const IconConstrain(
                          imagePath: Assets.imagesSave,
                          height: 22,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'حفظ علامة ',
                          style: AppStyles.styleDiodrumArabicMedium15(context)
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              QuranContainerButtons(
                iconHeight: 15,
                iconPath: Assets.imagesSaveFilled,
                text: 'الإنتقال إلي العلامة',
                onTap: () {
                  MaterialPageRoute(
                    builder: (context) => const SurahListWidget(),
                  );
                },
              ),
              QuranContainerButtons(
                iconHeight: 18,
                iconPath: Assets.imagesPage,
                text: 'صفحة ${widget.pageNumber} ',
                onTap: () {},
              ),
            ],
          ),
          Row(
            children: [
              QuranContainerButtons(
                iconHeight: 10.07,
                iconPath: Assets.imagesIndex,
                text: 'الفهرس',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SurahListWidget(),
                    ),
                  );
                },
              ),
              QuranContainerButtons(
                iconHeight: 15.3,
                iconPath: Assets.imagesVector,
                text: 'الأجزاء',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const JuzListPage(),
                    ),
                  );
                },
              ),
              QuranContainerButtons(
                iconHeight: 16.4,
                iconPath: Assets.imagesHand,
                text: 'دعاء الختم',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DoaaKhatmPage(),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
