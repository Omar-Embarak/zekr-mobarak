import 'package:azkar_app/pages/quran_pages/quran_text_page.dart';
import 'package:azkar_app/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:azkar_app/constants/colors.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:quran/quran.dart' as quran;

import 'list_surahs_listening_page.dart';

class MurattalPage extends StatelessWidget {
  MurattalPage({super.key});

  final List<String> recitersURL = [
    'abdul_baset',
    'abdurrahmaan_as_sudais',
    'abu_bakr_shatri',
    'hani_ar_rifai',
    'khalil_al_husary',
    'mishari_al_afasy',
    'siddiq_minshawi',
    'saud_ash-shuraym',
  ];

  final List<String> reciters = [
    'عبد الباسط عبد الصمد',
    'عبدالرحمن السديس',
    'ابو بكر الشاطري',
    'هاني الرفاعي',
    'خليل الحصري',
    'مشاري العفاسي',
    'صديق المنشاوي',
    'سعود الشريم',
  ];

  String getAudioUrl(int reciterIndex, String surahNumber) {
    return 'https://download.quranicaudio.com/qdc/${recitersURL[reciterIndex]}/murattal/$surahNumber.mp3';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.kSecondaryColor,
        title: Text(
          'القران المرتل',
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
                    audioBaseUrl:
                        'https://download.quranicaudio.com/qdc/${recitersURL[index]}/murattal/',
                    reciterName: reciters[index],
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              height: 53,
              margin: const EdgeInsets.only(top: 8, right: 8, left: 8),
              decoration: BoxDecoration(
                color: AppColors.kSecondaryColor,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Row(
                children: [
                  Text(
                    reciters[index],
                    style: AppStyles.styleCairoMedium15(context)
                        .copyWith(color: Colors.white),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
