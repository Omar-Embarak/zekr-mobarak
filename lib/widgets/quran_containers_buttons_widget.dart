import 'package:flutter/material.dart';

import '../utils/app_style.dart';
import 'icon_constrain_widget.dart';

class QuranContainerButtons extends StatelessWidget {
  const QuranContainerButtons({
    super.key,
    required this.onTap,
    required this.text,
    required this.iconPath,
    required this.iconHeight,
  });
  final void Function() onTap;
  final String text;
  final String iconPath;
  final double iconHeight;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            IconConstrain(height: iconHeight, imagePath: iconPath),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: AppStyles.styleDiodrumArabicMedium15(context)
                ,
            )
          ],
        ),
      ),
    );
  }
}
