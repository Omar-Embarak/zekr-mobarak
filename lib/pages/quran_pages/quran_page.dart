import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class QuranPage extends StatelessWidget {
  const QuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.kSecondaryColor,
        centerTitle: true,
        title: const Text(
          "القرآن الكريم",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
