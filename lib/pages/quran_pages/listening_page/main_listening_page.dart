import 'package:azkar_app/constants.dart';
import 'package:azkar_app/pages/quran_pages/listening_page/hadr_page.dart';
import 'package:azkar_app/pages/quran_pages/listening_page/mugawwad_page.dart';
import 'package:flutter/material.dart';
import '../../../widgets/listening_button.dart';
import 'favorite_page.dart';
import 'murattal_page.dart';

class ListeningPage extends StatelessWidget {
  const ListeningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'القران المسموع',
          style: TextStyle(color: Color(0xffffffff)),
        ),
        backgroundColor: AppColors.kSecondaryColor,
      ),
      backgroundColor: AppColors.kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(
              flex: 6,
            ),
            ListeningButtons(
              buttonText: 'مرتل',
              builder: (context) => MurattalPage(),
              color: const Color.fromARGB(255, 108, 0, 127),
            ),
            const Spacer(
              flex: 1,
            ),
            ListeningButtons(
              buttonText: 'مجود',
              builder: (context) => MugawwadPage(),
              color: const Color.fromARGB(255, 255, 170, 0),
            ),
            const Spacer(
              flex: 1,
            ),
            ListeningButtons(
              buttonText: 'حدر',
              builder: (context) => HadrPage(),
              color: const Color.fromARGB(255, 0, 216, 58),
            ),
            const Spacer(
              flex: 1,
            ),
            ListeningButtons(
              buttonText: 'المفضلة',
              builder: (context) => const FavoritePage(),
              color: const Color.fromARGB(255, 0, 194, 216),
            ),
            const Spacer(
              flex: 6,
            ),
          ],
        ),
      ),
    );
  }
}
