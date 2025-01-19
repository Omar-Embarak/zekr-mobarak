import 'package:flutter/material.dart';
import '../constants.dart';
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
      // Get screen dimensions for responsiveness
      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;

      return Container(
        decoration: BoxDecoration(color: AppColors.kSecondaryColor),
        height: screenHeight * 0.35, // Make height proportional to screen size
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.1, // Responsive height for title
                child: Center(
                  child: Text(
                    'القران الكريم',
                    style: AppStyles.styleCairoMedium15white(context),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04, // Responsive padding
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ListeningPage(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xff575757),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenHeight *
                                    0.15, // Responsive image height
                                child: Image.asset(
                                  Assets.imagesRectangle40,
                                  fit: BoxFit.contain, // Ensure image fits well
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01), // Spacing
                              Stack(
                                children: [
                                  Center(
                                    child: Text(
                                      'سماع',
                                      style: AppStyles.styleCairoMedium15white(
                                              context)
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: FittedBox(
                                      child: Icon(
                                        Icons.arrow_back_ios_new,
                                        color: Colors.white.withOpacity(0.5),
                                        size: screenWidth *
                                            0.05, // Responsive icon size
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        width: screenWidth * 0.04), // Space between buttons
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
                            color: const Color(0xff575757),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenHeight *
                                    0.15, // Responsive image height
                                child: Image.asset(
                                  Assets.imagesRectangle39,
                                  fit: BoxFit.contain, // Ensure image fits well
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01), // Spacing
                              Stack(
                                children: [
                                  Center(
                                    child: Text(
                                      'قراءة',
                                      style: AppStyles.styleCairoMedium15white(
                                              context)
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: FittedBox(
                                      child: Icon(
                                        Icons.arrow_back_ios_new,
                                        color: Colors.white.withOpacity(0.5),
                                        size: screenWidth *
                                            0.05, // Responsive icon size
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              )
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
