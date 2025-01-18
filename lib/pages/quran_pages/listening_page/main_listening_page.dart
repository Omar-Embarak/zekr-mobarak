import 'package:azkar_app/constants.dart';
import 'package:azkar_app/pages/quran_pages/listening_page/abi_alhareth.dart';
import 'package:azkar_app/pages/quran_pages/listening_page/dorie_page.dart';
import 'package:azkar_app/pages/quran_pages/listening_page/khalaf_page.dart';
import 'package:azkar_app/pages/quran_pages/listening_page/madina_page.dart';
import 'package:azkar_app/pages/quran_pages/listening_page/makka_page.dart';
import 'package:azkar_app/pages/quran_pages/listening_page/mugawwad_page.dart';
import 'package:azkar_app/pages/quran_pages/listening_page/qaloon_page.dart';
import 'package:azkar_app/pages/quran_pages/listening_page/quran_english.dart';
import 'package:azkar_app/pages/quran_pages/listening_page/sho3ba_page.dart';
import 'package:azkar_app/pages/quran_pages/listening_page/urdu_page.dart';
import 'package:azkar_app/pages/quran_pages/listening_page/warsh_page.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_style.dart';
import '../../../widgets/listening_button.dart';
import 'favorite_page.dart';
import 'murattal_page.dart';

class ListeningPage extends StatelessWidget {
  const ListeningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> buttonData = [
      {'text': 'المفضلة', 'page': const FavoritePage()},
      {'text': 'القرآن المرتل', 'page': const MurattalPage()},
      {'text': 'القرآن المجود', 'page': const MugawwadPage()},
      {'text': 'رواية ورش', 'page': const WarshPage()},
      {'text': 'رواية شعبة', 'page': const Sho3baPage()},
      {'text': 'رواية الدوري', 'page': const DoriePage()},
      {'text': 'رواية أبي الحارث', 'page': const AbiAlharethPage()},
      {'text': 'رواية قالون', 'page': const QaloonPage()},
      {'text': 'رواية خلف', 'page': const KhalafPage()},
      {'text': 'قران اردو', 'page': const UrduPage()},
      {'text': 'Quran English', 'page': const QuranEnglishPage()},
      {'text': 'قرآن مكة', 'page': const MakkaPage()},
      {'text': 'قرآن المدينة', 'page': const MadinaPage()},
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: AppStyles.styleCairoBold20(context).color),
        centerTitle: true,
        title: Text(
          'القران المسموع',
          style: AppStyles.styleCairoBold20(context),
        ),
        backgroundColor: AppColors.kSecondaryColor,
      ),
      backgroundColor: AppColors.kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 items per row
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 1.0, // Square aspect ratio
          ),
          itemCount: buttonData.length,
          itemBuilder: (context, index) {
            return ListeningButtons(
              buttonText: buttonData[index]['text'],
              builder: (context) => buttonData[index]['page'],
            );
          },
        ),
      ),
    );
  }
}
