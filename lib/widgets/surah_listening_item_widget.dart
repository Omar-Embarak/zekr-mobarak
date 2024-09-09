import 'package:azkar_app/constants/colors.dart';
import 'package:azkar_app/pages/quran_pages/quran_text_page.dart';
import 'package:azkar_app/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:quran/quran.dart' as quran;

class SurahListeningItem extends StatefulWidget {
  final int surahIndex;
  final String audioUrl;
  final void Function(int surahIndex)? onSurahTap;

  const SurahListeningItem({
    super.key,
    required this.surahIndex,
    required this.audioUrl,
    this.onSurahTap,
  });

  @override
  State<SurahListeningItem> createState() => _SurahListeningItemState();
}

class _SurahListeningItemState extends State<SurahListeningItem> {
  bool isExpanded = false;
  bool isPlaying = false;
  Duration totalDuration = Duration.zero;
  Duration currentDuration = Duration.zero;

  void togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
    // Add play/pause logic here
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
            if (widget.onSurahTap != null) {
              widget.onSurahTap!(widget.surahIndex);
            }
          },
          child: Container(
            height:
                isExpanded ? null : 53, // Make height flexible when expanded
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 10),
                    const IconConstrain(
                        height: 30, imagePath: Assets.imagesHeart),
                    const SizedBox(width: 10),
                    Text(
                      'سورة ${quran.getSurahNameArabic(widget.surahIndex + 1)}',
                      style: AppStyles.styleRajdhaniMedium18(context),
                    ),
                    const IconConstrain(
                        height: 30, imagePath: Assets.imagesShare),
                    const SizedBox(width: 10),
                    const IconConstrain(
                        height: 30, imagePath: Assets.imagesDocumentDownload),
                    const SizedBox(width: 10),
                  ],
                ),
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${currentDuration.inMinutes}:${(currentDuration.inSeconds % 60).toString().padLeft(2, '0')}',
                              style: AppStyles.styleRajdhaniMedium18(context),
                            ),
                            Text(
                              '${totalDuration.inMinutes}:${(totalDuration.inSeconds % 60).toString().padLeft(2, '0')}',
                              style: AppStyles.styleRajdhaniMedium18(context),
                            ),
                          ],
                        ),
                        Slider(
                          activeColor: AppColors.kSecondaryColor,
                          inactiveColor: AppColors.kPrimaryColor,
                          value: currentDuration.inSeconds.toDouble(),
                          max: totalDuration.inSeconds.toDouble(),
                          onChanged: (value) {
                            setState(() {
                              currentDuration =
                                  Duration(seconds: value.toInt());
                            });
                            // Implement seek logic
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const IconConstrain(
                                height: 24, imagePath: Assets.imagesNext),
                            const IconConstrain(
                                height: 24, imagePath: Assets.imagesForward),
                            IconButton(
                              icon: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow),
                              onPressed: togglePlayPause,
                            ),
                            const IconConstrain(
                                height: 24, imagePath: Assets.imagesBackward),
                            const IconConstrain(
                                height: 24, imagePath: Assets.imagesPrevious),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
