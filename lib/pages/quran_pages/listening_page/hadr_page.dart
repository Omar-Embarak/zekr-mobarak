import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../utils/app_style.dart';
import '../../../widgets/surahs_list_widget.dart';

class HadrPage extends StatelessWidget {
  HadrPage({super.key});

  final List<String> recitersURL = [];

  final List<String> reciters = [];
  String getAudioUrl(int reciterIndex, String surahNumber) {
    return 'https://download.quranicaudio.com/qdc/${recitersURL[reciterIndex]}/mugawwad/$surahNumber.mp3';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.kSecondaryColor,
        title: Text(
          'القران حدر',
          style: AppStyles.styleCairoBold20(context),
        ),
      ),
      body: SurahListWidget(
        onSurahTap: (surahIndex) {
          String audioUrl = getAudioUrl(0, surahIndex.toString());
          // Play audio using your preferred method
          print('Playing audio from: $audioUrl');
        },
      ),
    );
  }
}
