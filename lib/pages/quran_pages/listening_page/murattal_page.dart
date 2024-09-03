import 'package:azkar_app/widgets/surahs_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:azkar_app/constants/colors.dart';
import 'package:azkar_app/utils/app_style.dart';

class MurattalPage extends StatelessWidget {
  MurattalPage({super.key});

  final List<String> recitersURL = [
    'abdul_baset',
    'abdurrahmaan_as_sudais',
    'abu_bakr_shatri',
  ];

  final List<String> reciters = [
    'عبد الباسط عبد الصمد',
    'عبدالرحمن السديس',
    'ابو بكر الشاطري',
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
              // Navigate to the SurahListPage directly without wrapping with MaterialApp
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SurahListWidget(
                    onSurahTap: (surahIndex) {
                      String audioUrl = getAudioUrl(0, surahIndex.toString());
                      // Play audio using your preferred method
                      print('Playing audio from: $audioUrl');
                    },
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(top: 8, right: 8, left: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                reciters[index],
                style: AppStyles.styleRajdhaniBold20(context)
                    .copyWith(color: Colors.black),
              ),
            ),
          );
        },
      ),
    );
  }
}
