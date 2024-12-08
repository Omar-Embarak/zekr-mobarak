import 'package:azkar_app/constants.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/material.dart';

class MainCategoryWidget extends StatelessWidget {
  final String categoryImg;
  final String categoryTitle;
  const MainCategoryWidget(
      {super.key,
      required this.categoryImg,
      required this.categoryTitle,
      required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.kSecondaryColor,
      ),
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Column(
          children: [
            Image.asset(categoryImg),
            Text(categoryTitle, style: AppStyles.styleCairoBold20(context)),
          ],
        ),
      ),
    );
  }
}