import 'package:flutter/material.dart';
import '../constants.dart';
import '../utils/app_style.dart';

class ListeningButtons extends StatelessWidget {
  const ListeningButtons({
    super.key,
    required this.builder,
    required this.buttonText,
  });

  final String buttonText;
  final Widget Function(BuildContext) builder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: builder),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: AppColors.kSecondaryColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: .3,
            )
          ],
        ),
        child: Center(
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: AppStyles.styleDiodrumArabicbold20(context),
          ),
        ),
      ),
    );
  }
}
