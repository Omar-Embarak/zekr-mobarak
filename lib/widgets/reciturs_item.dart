import 'package:flutter/material.dart';
import '../constants.dart';
import '../utils/app_style.dart';

class RecitursItem extends StatelessWidget {
  const RecitursItem({
    super.key,
    required this.Title,
    this.description,
  });

  final String Title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 53, // Set a minimum height for the container
      ),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, right: 8, left: 8),
      decoration: BoxDecoration(
        color: AppColors.kSecondaryColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align to the top
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the left
              children: [
                Text(
                  Title,
                  style: AppStyles.styleCairoMedium15white(context),
                  maxLines: 2, // Limit text to 2 lines to prevent overflow
                  overflow:
                      TextOverflow.ellipsis, // Add ellipsis for truncated text
                ),
                if (description != null && description!.isNotEmpty) ...[
                  const SizedBox(
                      height: 5), // Add spacing between reciter and description
                  Text(
                    description!,
                    style: AppStyles.styleCairoMedium10(context),
                    maxLines: 3, // Limit description to 3 lines
                    overflow: TextOverflow.ellipsis, // Truncate with ellipsis
                  ),
                ],
              ],
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
