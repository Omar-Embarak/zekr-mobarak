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
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: IntrinsicHeight(
        // Adjust height based on the tallest child
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Match the tallest child
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 50,
              child: Image.asset(
                Assets.imagesRightborderRemovebgPreview,
                fit: BoxFit.cover, // Cover the container completely
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to the left
                children: [
                  Text(
                    title,
                    style: AppStyles.alwaysBlack18(context),
                    maxLines: 2, // Limit text to 2 lines to prevent overflow
                    overflow: TextOverflow.ellipsis, // Truncate long text
                  ),
                  if (description != null && description!.isNotEmpty) ...[
                    const SizedBox(
                        height: 5), // Add spacing between title and description
                    Text(
                      description!,
                      style: AppStyles.styleRajdhaniBold13(context)
                          .copyWith(color: Colors.black),
                      maxLines: 3, // Limit description to 3 lines
                      overflow: TextOverflow.ellipsis, // Truncate long text
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.black,
              size: 20, // Fixed size for the icon
            ),
          ],
        ),
      ),
    );
  }
}
