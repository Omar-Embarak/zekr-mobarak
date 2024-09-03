import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../pages/quran_pages/listening_page/main_listening_page.dart';
import '../pages/quran_pages/quran_reading_main_page.dart';
import '../utils/app_images.dart';
import '../utils/app_style.dart';

Future<dynamic> modalBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    context: context,
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(color: AppColors.kSecondaryColor),
        height: 256, // Set the height to 256

        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 60,
                child: Center(
                  child: Text('القران الكريم',
                      style: AppStyles.styleRajdhaniBold20(context)
                          .copyWith(color: Colors.white)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const ListeningPage()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xff575757)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 99,
                            child: Image.asset(Assets.imagesRectangle40),
                          ),
                          Text(
                            'سماع',
                            style:
                                AppStyles.styleCairoMedium15(context).copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const QuranReadingMainPage(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xff575757)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 99,
                            child: Image.asset(Assets.imagesRectangle39),
                          ),
                          Text(
                            'قراءة',
                            style:
                                AppStyles.styleCairoMedium15(context).copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
