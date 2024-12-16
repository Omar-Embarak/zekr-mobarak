import 'package:flutter/material.dart';

import '../constants.dart';
import '../utils/app_style.dart';

class MainCategoryWidget extends StatelessWidget {
  final String categoryImg;
  final String categoryTitle;
  final double width;

  const MainCategoryWidget({
    super.key,
    required this.categoryImg,
    required this.categoryTitle,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width > 0 ? width : 0, // Ensure width is never negative
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.kSecondaryColor,
      ),
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(categoryImg),
            const SizedBox(height: 10), // Spacing between image and text
            Text(
              categoryTitle,
              style: AppStyles.styleCairoBold20(context),
              textAlign: TextAlign.center, // Center align long text
            ),
          ],
        ),
      ),
    );
  }
}
