import 'package:azkar_app/pages/quran_pages/quran_text_page.dart';
import 'package:azkar_app/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:quran/quran.dart' as quran;

import '../../../constants/colors.dart';
import '../../../widgets/surah_listening_item_widget.dart';

class ListSurahsListeningPage extends StatefulWidget {
  final String audioBaseUrl;
  final String reciterName;
  final bool zeroPadding;
  const ListSurahsListeningPage({
    super.key,
    required this.audioBaseUrl,
    required this.reciterName, required this.zeroPadding,
  });

  @override
  State<ListSurahsListeningPage> createState() =>
      _ListSurahsListeningPageState();
}

class _ListSurahsListeningPageState extends State<ListSurahsListeningPage> {
  String? tappedSurahName;

  void updateTappedSurahName(int surahIndex) {
    setState(() {
      tappedSurahName =
          'تشغيل سورة ${quran.getSurahNameArabic(surahIndex + 1)} الآن';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kSecondaryColor,
      appBar: AppBar(
        title: const Text('استماع القران الكريم'),
        backgroundColor: AppColors.kPrimaryColor,
        leading:
            const IconConstrain(height: 24, imagePath: Assets.imagesSearch),
      ),
      body: Column(
        children: [
          // Non-scrollable content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  widget.reciterName,
                  style: AppStyles.styleCairoBold20(context),
                ),
                if (tappedSurahName != null)
                  Text(
                    tappedSurahName!,
                    style: AppStyles.styleCairoMedium15(context)
                        .copyWith(color: Colors.white),
                  ),
              ],
            ),
          ),
          // Scrollable ListView
          Expanded(
            child: ListView.builder(
              itemCount: 114,
              itemBuilder: (BuildContext context, int index) {
                final surahNumber =widget.zeroPadding?  (index + 1) .toString().padLeft(3, '0'):(index + 1);
              
                final audioUrl = '${widget.audioBaseUrl}$surahNumber.mp3';
                return SurahListeningItem(
                  surahIndex: index,
                  audioUrl: audioUrl,
                  onSurahTap: updateTappedSurahName,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
