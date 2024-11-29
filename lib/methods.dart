import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'constants.dart';

Future<Map<String, dynamic>> loadJSONDataMap(String path) async {
  try {
    final String response = await rootBundle.loadString(path);
    final data = json.decode(response);
    return data as Map<String, dynamic>; // Return the loaded Map
  } catch (e) {
    debugPrint('Error loading JSON: $e');
    return {}; // Return an empty Map in case of error
  }
}

void showMessage(String message) {
  Fluttertoast.showToast(
      msg: message, backgroundColor: Colors.black.withOpacity(0.5));
}

Future<List<dynamic>> loadJSONDataList(String path) async {
  try {
    final String response = await rootBundle.loadString(path);
    final data = json.decode(response);
    return data; // Return the loaded data
  } catch (e) {
    debugPrint('Error loading JSON: $e');
    return []; // Return an empty list in case of error
  }
}

void initializeAudioPlayer(
    AudioPlayer audioPlayer,
    Function(Duration) setTotalDuration,
    Function(Duration) setCurrentDuration,
    Function(bool) setIsPlaying) {
  audioPlayer.onDurationChanged.listen((Duration duration) {
    setTotalDuration(duration);
  });
  audioPlayer.onPositionChanged.listen((Duration position) {
    setCurrentDuration(position);
  });
  audioPlayer.onPlayerComplete.listen((event) {
    setIsPlaying(false);
    setCurrentDuration(Duration.zero);
  });
}

Future<void> togglePlayPause(AudioPlayer audioPlayer, bool isPlaying,
    String audioUrl, Function(bool) setIsPlaying) async {
  if (isPlaying) {
    await audioPlayer.pause();
  } else {
    await audioPlayer.play(UrlSource(audioUrl));
  }
  setIsPlaying(!isPlaying);
}

void adjustSpeed(AudioPlayer audioPlayer, double speed) async {
  await audioPlayer.setPlaybackRate(speed);
}

void showTafseer({
  required BuildContext context, // Explicitly pass context
  required int surahNumber,
  required int verseNumber,
}) async {
  try {
    // Show loading spinner while fetching data
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Load tafseer JSON data
    final tafseerSurah = await loadJSONDataMap(
      'assets/quranjson/translation/ar/ar_translation_$surahNumber.json',
    );

    // Extract the tafseer for the specified verse
    final tafseerAyah = tafseerSurah['verse']?['verse_$verseNumber'] ??
        'تفسير غير متاح لهذه الآية';

    // Close the loading dialog
    Navigator.of(context).pop();

    // Display tafseer in a bottom sheet
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
              color: AppColors.kSecondaryColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: SingleChildScrollView(
            child: Text(
              tafseerAyah,
              style: AppStyles.styleAmiriMedium30(context)
                  .copyWith(color: Colors.white),
              textAlign: TextAlign.justify,
            ),
          ),
        );
      },
    );
  } catch (error) {
    // Close the loading dialog in case of an error
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();

    // Log the error for debugging
    log('Error loading tafseer: $error');

    // Show error message
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خطأ'),
        content: const Text('تعذر تحميل التفسير. يرجى المحاولة لاحقًا.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}

void forward(AudioPlayer audioPlayer) {
  adjustSpeed(audioPlayer, 1.25);
  showMessage('الصوت علي سرعة 1.25');
}

void backward(AudioPlayer audioPlayer) {
  adjustSpeed(audioPlayer, 0.75);
  showMessage('الصوت علي سرعة 0.75');
}

Future<void> shareAudio(String audioUrl) async {
  Share.share(audioUrl);
}

Future<void> downloadAudio(
    String audioUrl, String title, BuildContext context) async {
  if (await requestPermission(Permission.storage)) {
    final dir = await getExternalStorageDirectory();
    if (dir != null) {
      String fileName = "$title.mp3";
      String filePath = "${dir.path}/$fileName";

      Dio dio = Dio();
      await dio.download(audioUrl, filePath);

      showMessage('$fileName Downloaded at $filePath');
    }
  }
}

Future<bool> requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    var result = await permission.request();
    return result == PermissionStatus.granted;
  }
}

void playNextSurah(
    AudioPlayer audioPlayer,
    int surahIndex,
    Function(int) onSurahTap,
    String audioUrl,
    Function(bool) setIsPlaying) async {
  final nextSurahIndex = surahIndex + 1;
  if (nextSurahIndex < 114) {
    onSurahTap(nextSurahIndex);
    await audioPlayer.pause();
    final nextAudioUrl = audioUrl.replaceFirst(
      (surahIndex + 1).toString().padLeft(3, '0'),
      (nextSurahIndex + 1).toString().padLeft(3, '0'),
    );
    await audioPlayer.play(UrlSource(nextAudioUrl));
    setIsPlaying(true);
  }
}

void playPreviousSurah(int surahIndex, Function(int) onSurahTap) {
  final previousSurahIndex = surahIndex - 1;
  if (previousSurahIndex >= 0) {
    onSurahTap(previousSurahIndex);
  }
}
