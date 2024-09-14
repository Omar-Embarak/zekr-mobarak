import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../utils/app_style.dart';

class RecitursItem extends StatelessWidget {
  const RecitursItem({
    super.key,
    required this.reciter,
  });
  final String reciter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      height: 53,
      margin: const EdgeInsets.only(top: 8, right: 8, left: 8),
      decoration: BoxDecoration(
        color: AppColors.kSecondaryColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        children: [
          Text(
            reciter,
            style: AppStyles.styleCairoMedium15(context)
                .copyWith(color: Colors.white),
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios_outlined,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
