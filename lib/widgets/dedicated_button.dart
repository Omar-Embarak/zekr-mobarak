import 'package:azkar_app/constants.dart';
import 'package:flutter/material.dart';

import '../utils/app_style.dart';

class DedicationButton extends StatelessWidget {
  const DedicationButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        // Show an AlertDialog with information
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.kSecondaryColor,
            title: Text(
              "اهداء",
              style: TextStyle(
                color: AppStyles.styleDiodrumArabicbold20(context).color,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: Center(
                child: Text(
                  '''
    اللهم اجعله خالصا لوجهك الكريم وانفع به المسلمين واجز كل من ساهم فيه وفي نشره خيرا
    
    صدقة جارية عن أبي امبارك ورداني رحمه الله وأمواتنا واموات المسلمين أجمعين وعن امي واخواتي وأبنائهم وازواجهم وزوجتي واولادي وأهلي جميعا وعن المسلمين أجمعين
                  '''
                      .trim(),
                  style: TextStyle(
                    color: AppStyles.styleDiodrumArabicbold20(context).color,
                    fontFamily: "Amiri",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "امين",
                  style: TextStyle(
                    color: AppStyles.styleDiodrumArabicbold20(context).color,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.info_outline),
    );
  }
}
