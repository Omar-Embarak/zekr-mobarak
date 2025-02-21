import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../model/quran_models/reciters_model.dart';
import '../../../utils/app_style.dart';
import '../../../widgets/reciturs_item.dart';
import 'list_surahs_listening_page.dart';

class KhalafPage extends StatelessWidget {
  const KhalafPage({super.key});

  final List<RecitersModel> reciters = const [
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/abdurrashid_sufi_-_khalaf_3an_7amza_recitation//',
      name: 'عبد الرشيد صوفي برواية خلف عن حمزة ',
      zeroPaddingSurahNumber: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.kSecondaryColor,
        title: Text(
          'رواية خلف',
          style: AppStyles.styleDiodrumArabicbold20(context),
        ),
      ),
      body: ListView.builder(
        itemCount: reciters.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListSurahsListeningPage(
                    reciter: reciters[index],
                  ),
                ),
              );
            },
            child: RecitursItem(
              title: reciters[index].name,
            ),
          );
        },
      ),
    );
  }
}
