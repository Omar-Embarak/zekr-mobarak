import 'package:azkar_app/constants/colors.dart';
import 'package:flutter/material.dart';

class MainCategoryWidget extends StatelessWidget {
  final String categoryImg;
  final String categoryTitle;
  const MainCategoryWidget(
      {super.key, required this.categoryImg, required this.categoryTitle, required this.width});
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.kSecondaryColor),
      padding: EdgeInsets.all(8),
      child: Center(
        child: Column(
          children: [
            Container(
              child: Image.asset(categoryImg),
            ),
            Text(
              categoryTitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
