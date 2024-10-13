import 'package:azkar_app/model/quran_models/reciters_model.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../utils/app_style.dart';
import '../../../widgets/reciturs_item.dart';
import 'list_surahs_listening_page.dart';

class MadinaPage extends StatelessWidget {
  const MadinaPage({super.key});
  final List<RecitersModel> reciters = const [
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1419//',
      name: 'قران المدينة 1419',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1423//',
      name: 'قران المدينة 1423 ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1426//',
      name: 'قران المدينة 1426',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1427//',
      name: 'قران المدينة 1427',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1428//',
      name: 'قران المدينة 1428',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1429//',
      name: 'قران المدينة 1429  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1430//',
      name: 'قران المدينة 1430  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1431//',
      name: 'قران المدينة 1431 ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1432//',
      name: 'قران المدينة 1432  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1433//',
      name: 'قران المدينة 1433  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1434//',
      name: 'قران المدينة 1434  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1435//',
      name: 'قران المدينة 1435  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1436//',
      name: 'قران المدينة 1436  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1437//',
      name: 'قران المدينة 1437  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1439//',
      name: 'قران المدينة 1439  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1440//',
      name: 'قران المدينة 1440  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1441//',
      name: 'قران المدينة 1441  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1442//',
      name: 'قران المدينة 1442  ',
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
          'قرآن المدينة',
          style: AppStyles.styleCairoBold20(context),
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
                  builder: (context) => ListSurahsListeningPage(                    reciter: reciters[index],

                  ),
                ),
              );
            },
            child: RecitursItem(
              reciter: reciters[index].name,
            ),
          );
        },
      ),
    );
  }
}
