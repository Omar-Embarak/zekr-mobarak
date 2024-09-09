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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
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
                              Stack(
                                children: [
                                  Center(
                                    child: Text(
                                      'سماع',
                                      style:
                                          AppStyles.styleCairoMedium15(context)
                                              .copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                   Positioned(
                                    right: 0,
                                    child: FittedBox(
                                      child: Icon(
                                        Icons.arrow_back_ios_new,
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16), // Space between the two buttons
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const QuranReadingMainPage(),
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
                              Stack(
                                children: [
                                  Center(
                                    child: Text(
                                      'قراءة',
                                      style:
                                          AppStyles.styleCairoMedium15(context)
                                              .copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: FittedBox(
                                      child: Icon(
                                        Icons.arrow_back_ios_new,
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
