import 'package:flutter/material.dart';

import '../constants.dart';
import '../utils/app_style.dart';

class MainCategoryWidget extends StatelessWidget {
  final String categoryImg;
  final String categoryTitle;

  const MainCategoryWidget({
    super.key,
    required this.categoryImg,
    required this.categoryTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.kSecondaryColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: .3,
          )
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(
              categoryImg,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            categoryTitle,
            style: AppStyles.styleDiodrumArabicbold20(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
