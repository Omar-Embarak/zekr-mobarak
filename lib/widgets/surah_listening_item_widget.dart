import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:quran/quran.dart' as quran;
import 'package:azkar_app/constants/colors.dart';
import 'package:azkar_app/utils/app_images.dart';
import '../methods.dart';
import '../pages/quran_pages/listening_page/favorite_page.dart';
import 'icon_constrain_widget.dart';

class SurahListeningItem extends StatefulWidget {
  final int surahIndex;
  final String audioUrl;
  final void Function(int surahIndex)? onSurahTap;
  final String reciterName;
  const SurahListeningItem({
    super.key,
    required this.surahIndex,
    required this.audioUrl,
    this.onSurahTap, required this.reciterName,
  });

  @override
  State<SurahListeningItem> createState() => _SurahListeningItemState();
}

class _SurahListeningItemState extends State<SurahListeningItem> {
  bool isExpanded = false;
  bool isPlaying = false;
  bool isFavorite = false; // Add this flag to track favorite status
  Duration totalDuration = Duration.zero;
  Duration currentDuration = Duration.zero;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    initializeAudioPlayer(
        _audioPlayer, setTotalDuration, setCurrentDuration, setIsPlaying);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void setTotalDuration(Duration duration) {
    setState(() {
      totalDuration = duration;
    });
  }

  void setCurrentDuration(Duration duration) {
    setState(() {
      currentDuration = duration;
    });
  }

  void setIsPlaying(bool playing) {
    setState(() {
      isPlaying = playing;
    });
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      if (isFavorite) {
        // Add surah to favorite list
        favItems.add(FavModel(
          url: widget.audioUrl,
          reciterName: widget.reciterName, // replace with actual reciter name
          surahName: quran.getSurahNameArabic(widget.surahIndex + 1),
        ));
      } else {
        // Remove from favorite list
        favItems.removeWhere((item) =>
            item.surahName == quran.getSurahNameArabic(widget.surahIndex + 1));
      }
    });
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
          child: buildSurahItem(),
        ),
      ],
    );
  }

  Widget buildSurahItem() {
    return Container(
      height: isExpanded ? null : 53,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildSurahRow(),
          if (isExpanded) buildExpandedContent(),
        ],
      ),
    );
  }

  Widget buildSurahRow() {
    return Row(
      children: [
        const SizedBox(width: 10),
        GestureDetector(
          onTap: toggleFavorite, // Call toggleFavorite on tap
          child: Icon(
            Icons.favorite,
            color: isFavorite
                ? Colors.red
                : null, // Change color based on favorite status
            size: 30,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'سورة ${quran.getSurahNameArabic(widget.surahIndex + 1)}',
          style: AppStyles.styleRajdhaniMedium18(context),
        ),
        const Spacer(),
        buildActionButtons(),
      ],
    );
  }

  Widget buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => shareAudio(widget.audioUrl),
          child: const IconConstrain(height: 30, imagePath: Assets.imagesShare),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () =>
              downloadAudio(widget.audioUrl, widget.surahIndex, context),
          child: const IconConstrain(
              height: 30, imagePath: Assets.imagesDocumentDownload),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget buildExpandedContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          buildDurationRow(),
          buildSlider(),
          buildControlButtons(),
        ],
      ),
    );
  }

  Widget buildDurationRow() {
    return Row(
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
    );
  }

  Widget buildSlider() {
    return Slider(
      activeColor: AppColors.kSecondaryColor,
      inactiveColor: AppColors.kPrimaryColor,
      value: currentDuration.inSeconds.toDouble(),
      max: totalDuration.inSeconds.toDouble(),
      onChanged: (value) {
        setState(() {
          currentDuration = Duration(seconds: value.toInt());
        });
        _audioPlayer.seek(currentDuration);
      },
    );
  }

  Widget buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () => playNextSurah(_audioPlayer, widget.surahIndex,
              widget.onSurahTap!, widget.audioUrl, setIsPlaying),
          child: const IconConstrain(height: 24, imagePath: Assets.imagesNext),
        ),
        GestureDetector(
          onTap: () => forward(_audioPlayer),
          child:
              const IconConstrain(height: 24, imagePath: Assets.imagesForward),
        ),
        IconButton(
          onPressed: () => togglePlayPause(
              _audioPlayer, isPlaying, widget.audioUrl, setIsPlaying),
          icon: Icon(
            isPlaying ? Icons.pause_circle : Icons.play_circle,
            color: AppColors.kSecondaryColor,
            size: 45,
          ),
        ),
        GestureDetector(
          onTap: () => backward(_audioPlayer),
          child:
              const IconConstrain(height: 24, imagePath: Assets.imagesBackward),
        ),
        GestureDetector(
          onTap: () => playPreviousSurah(widget.surahIndex, widget.onSurahTap!),
          child:
              const IconConstrain(height: 24, imagePath: Assets.imagesPrevious),
        ),
      ],
    );
  }
}
