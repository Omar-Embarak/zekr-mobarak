import 'package:flutter/material.dart';
import '../constants.dart';
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
      constraints: const BoxConstraints(
        minHeight: 53, // Set minimum height
      ),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, right: 8, left: 8),
      decoration: BoxDecoration(
        color: AppColors.kSecondaryColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              reciter,
              style: AppStyles.styleCairoMedium15(context)
                  .copyWith(color: Colors.white),
              maxLines: null, // Allow text to expand over multiple lines
              overflow: TextOverflow.visible, // Show all text
            ),
          ),
          const SizedBox(width: 10), // Add space between text and icon
          const Icon(
            Icons.arrow_forward_ios_outlined,
            color: Colors.white,
            size: 20, // Ensure the icon has a fixed size for consistency
          ),
        ],
      ),
    );
  }
}
