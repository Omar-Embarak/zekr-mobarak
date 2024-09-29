import 'package:azkar_app/model/quran_models/reciters_model.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../utils/app_style.dart';
import '../../../widgets/reciturs_item.dart';
import 'list_surahs_listening_page.dart';

class MakkaPage extends StatelessWidget {
  const MakkaPage({super.key});

  final List<RecitersModel> reciters = const[
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1424//',
      name: 'قران مكة 1424 ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1425//',
      name: 'قران مكة 1425 ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1426//',
      name: 'قران مكة 1426',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1427//',
      name: 'قران مكة 1427',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1428//',
      name: 'قران مكة 1428 ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1429//',
      name: 'قران مكة 1429 ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1430//',
      name: 'قران مكة 1430 ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1431//',
      name: 'قران مكة 1431 ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1432//',
      name: 'قران مكة 1432  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1433//',
      name: 'قران مكة 1433  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1434//',
      name: 'قران مكة 1434  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1435//',
      name: 'قران مكة 1435  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1436//',
      name: 'قران مكة 1436  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1437//',
      name: 'قران مكة 1437  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1438//',
      name: 'قران مكة 1438  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1439//',
      name: 'قران مكة 1439  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1440//',
      name: 'قران مكة 1440  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1441//',
      name: 'قران مكة 1441  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1442//',
      name: 'قران مكة 1442  ',
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
          'القران مكة',
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
                  builder: (context) => ListSurahsListeningPage(
                    audioBaseUrl: reciters[index].url,
                    reciterName: reciters[index].name,
                    zeroPadding: reciters[index].zeroPaddingSurahNumber,
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
