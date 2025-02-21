import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../model/quran_models/reciters_model.dart';
import '../../../utils/app_style.dart';
import '../../../widgets/reciturs_item.dart';
import 'list_surahs_listening_page.dart';

class TraweehPage extends StatelessWidget {
  const TraweehPage({super.key});

  final List<RecitersModel> reciters = const [
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/abu_bakr_ash-shatri_tarawee7//',
      name: 'أبو بكر الشاطري - تراويح  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/hatem_farid/taraweeh1430//',
      name: 'حاتم فريد - تراويح 1430  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/hatem_farid/taraweeh1431//',
      name: 'حاتم فريد - تراويح 1431 ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/hatem_farid/taraweeh1432//',
      name: 'حاتم فريد - تراويح 1432 ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/hatem_farid/taraweeh1434//',
      name: 'حاتم فريد - تراويح 1434  ',
      zeroPaddingSurahNumber: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: AppStyles.styleCairoMedium15white(context).color),
        backgroundColor: AppColors.kSecondaryColor,
        title: Text(
          'تراويح',
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
