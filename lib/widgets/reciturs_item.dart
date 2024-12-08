import 'package:azkar_app/utils/app_images.dart';
import 'package:flutter/material.dart';
import '../utils/app_style.dart';

class RecitursItem extends StatelessWidget {
  const RecitursItem({
    super.key,
    required this.title,
    this.description,
  });

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, right: 8, left: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Center items vertically
        children: [
          Flexible(
            flex: 1, // Allow the image to adjust height based on container
            child: Image.asset(
              Assets.imagesRightborderRemovebgPreview,
              fit: BoxFit.fill, // Ensure the image fills its container
            ),
          ),
          Expanded(
            flex: 8, // Assign most space to the text column
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the left
              children: [
                Text(
                  title,
                  style: AppStyles.styleRajdhaniMedium15(context)
                      .copyWith(color: Colors.black),
                  maxLines: 2, // Limit text to 2 lines to prevent overflow
                  overflow:
                      TextOverflow.ellipsis, // Add ellipsis for truncated text
                ),
                if (description != null && description!.isNotEmpty) ...[
                  const SizedBox(
                      height: 5), // Add spacing between title and description
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
            color: Colors.black,
            size: 20, // Ensure the icon has a fixed size for consistency
          ),
        ],
      ),
    );
  }
}
