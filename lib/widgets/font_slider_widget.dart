import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../pages/quran_pages/quran_font_size_provider.dart';
import '../utils/app_style.dart';

class FontSlider extends StatelessWidget {
  const FontSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'أ',
          style: AppStyles.styleDiodrumArabicMedium11(context),
        ),
        Expanded(
          child: Consumer<QuranFontSizeProvider>(
            builder: (context, fontSizeProvider, child) {
              return Slider(
                activeColor: AppColors.kPrimaryColor,
                inactiveColor: AppStyles.themeNotifier.value == darkTheme
                    ? Colors.white
                    : AppColors.kSecondaryColor,
                value: fontSizeProvider.fontSize,
                min: 15,
                max: 60,
                onChanged: (value) {
                  fontSizeProvider.fontSize = value;
                },
              );
            },
          ),
        ),
        Text(
          'أ',
          style: AppStyles.styleDiodrumArabicMedium15(context),
        ),
      ],
    );
  }
}
