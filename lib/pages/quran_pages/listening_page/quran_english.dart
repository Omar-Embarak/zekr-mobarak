import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../model/quran_models/reciters_model.dart';
import '../../../utils/app_style.dart';
import '../../../widgets/reciturs_item.dart';
import 'list_surahs_listening_page.dart';

class QuranEnglishPage extends StatelessWidget {
  const QuranEnglishPage({super.key});

  final List<RecitersModel> reciters = const [
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/sudais_shuraim_and_english//',
      name: 'Sudais, Shuraim and English',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/shakir_qasami_with_english/',
      name: 'Shakir Qasami and English',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/mishaari_with_saabir_mkhan//',
      name: 'Mishari Alafasy and Saabir Mkhan',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/abdulbasit_w_ibrahim_walk_si//',
      name: 'Abdulbasit and Ibrahim Walksi',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/mishaari_w_ibrahim_walk_si//',
      name: 'Mishari Alafasy and Ibrahim Walksi',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/abdullah_basfar_w_ibrahim_walk_si//',
      name: 'Abdullah Basfar and Ibrahim Walksi',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/abdulbaset_with_naeem_sultan_pickthall//',
      name: 'Abdulbasit and Naeem Sultan ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/sudais_shuraim_with_naeem_sultan_pickthall//',
      name: 'Sudais, Shuraim with Naeem Sultan ',
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
          'Quran English',
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
