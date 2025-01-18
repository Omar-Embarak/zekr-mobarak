import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'constants.dart';
import 'dart:io';

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

Future<void> togglePlayPause(
    AudioPlayer audioPlayer,
    bool isPlaying,
    String audioUrl,
    Function(bool) setIsPlaying,
    void Function()? onSurahTap) async {
  if (isPlaying) {
    await audioPlayer.pause();
  } else {
    await audioPlayer.play(UrlSource(audioUrl));
    if (onSurahTap != null) {
      onSurahTap();
    }
  }
  setIsPlaying(!isPlaying);
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
          decoration: BoxDecoration(
              color: AppColors.kSecondaryColor,
              borderRadius: const BorderRadius.only(
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

double currentSpeed = 1.0; // Track the current speed of playback

void adjustSpeed(AudioPlayer audioPlayer, double speed) async {
  currentSpeed = speed; // Update the speed state
  await audioPlayer.setPlaybackRate(currentSpeed);
}

void forward(AudioPlayer audioPlayer) {
  if (currentSpeed == 1.0) {
    currentSpeed = 1.25; // Increase speed to 1.25
  } else if (currentSpeed == 0.75) {
    currentSpeed = 1.0; // Reset to normal speed
  }
  adjustSpeed(audioPlayer, currentSpeed);
  showMessage('الصوت علي سرعة ${currentSpeed.toStringAsFixed(2)}');
}

void backward(AudioPlayer audioPlayer) {
  if (currentSpeed == 1.0) {
    currentSpeed = 0.75; // Decrease speed to 0.75
  } else if (currentSpeed == 1.25) {
    currentSpeed = 1.0; // Reset to normal speed
  }
  adjustSpeed(audioPlayer, currentSpeed);
  showMessage('الصوت علي سرعة ${currentSpeed.toStringAsFixed(2)}');
}

Future<void> shareAudio(String audioUrl) async {
  Share.share(audioUrl);
}

Future<void> downloadAudio(
    String audioUrl, String title, BuildContext context) async {
  if (await requestPermission(Permission.storage)) {
    // Manually construct the path to the Downloads directory
    Directory dir = Directory('/storage/emulated/0/Download');

    if (await dir.exists()) {
      String fileName = "$title.mp3";
      String filePath = "${dir.path}/$fileName";

      Dio dio = Dio();
      await dio.download(audioUrl, filePath,
          onReceiveProgress: (received, total) {
        if (total != -1) {
          print(
              "Download progress: ${(received / total * 100).toStringAsFixed(0)}%");
        }
      });

      showMessage('$fileName Downloaded at $filePath');
    } else {
      showMessage('Download directory does not exist');
    }
  }
}

String removeTashkeel(String text) {
  // Regular expression to remove diacritics (Tashkeel)
  const tashkeelRegex = '[\u064B-\u065F\u06D6-\u06ED]';
  text = text.replaceAll(RegExp(tashkeelRegex), '');

  // Replace all forms of "ا" with the base form "ا"
  const alefVariantsRegex =
      '[\u0622\u0623\u0625\u0671]'; // Variants: ٱ, أ, إ, etc.
  text = text.replaceAll(RegExp(alefVariantsRegex), 'ا');

  return text;
}

Future<bool> requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    var result = await permission.request();
    return result == PermissionStatus.granted;
  }
}

String normalizeArabic(String text) {
  String withoutTashkeel = text.replaceAll(RegExp(r'[ًٌٍَُِّْۡ]'), '');
  String normalized = withoutTashkeel
      .replaceAll(RegExp(r'[أإٱآٰ]'), 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll('ة', 'ه')
      .trim(); // Trim spaces
  return normalized;
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
