import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:azkar_app/utils/app_style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'constants.dart';
import 'dart:io';

import 'pages/sevices/audio_handler.dart';

/// Define the MethodChannel that matches the one in your MainActivity.
const MethodChannel _mediaScannerChannel =
    MethodChannel('com.omar.zekr_mobarak/media_scanner');

/// Custom function to trigger a media scan via the platform channel.
/// This notifies Android to update its media database so that the file shows in file managers.

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
  // audioPlayer.onDurationChanged.listen((Duration duration) {
  //   setTotalDuration(duration);
  // });
  // audioPlayer.onPositionChanged.listen((Duration position) {
  //   setCurrentDuration(position);
  // });
  // audioPlayer.onPlayerComplete.listen((event) {
  //   setIsPlaying(false);
  //   setCurrentDuration(Duration.zero);
  // });
}

Future<bool> isUrlAccessible(String url) async {
  try {
    final response = await http.head(Uri.parse(url));
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
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
              style: AppStyles.styleDiodrumArabicbold20(context).copyWith(),
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
  // await audioPlayer.setPlaybackRate(currentSpeed);
}

void backward(AudioPlayerHandler audioHandler) async {
  // Old: seek backward 10 seconds
  // Now: decrease playback speed
  await audioHandler.decreaseSpeed();
}

void forward(AudioPlayerHandler audioHandler) async {
  // Old: seek forward 10 seconds
  // Now: increase playback speed
  await audioHandler.increaseSpeed();
}

Future<void> shareAudio(String audioUrl) async {
  Share.share(audioUrl);
}

/// Requests the given [permission] and returns true if granted.
Future<bool> requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    var result = await permission.request();
    return result == PermissionStatus.granted;
  }
}

void showMessage(String message) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor:
        const Color.fromRGBO(0, 0, 0, 0.5), // لون أسود بنسبة شفافية 50%
  );
}

/// Creates (if needed) and returns a custom download directory.
///
/// On Android, this function returns a folder inside the public Downloads folder,
/// making the file accessible by file managers. On other platforms, it falls back to
/// the app’s documents directory.
Future<Directory?> getCustomDownloadDirectory() async {
  if (Platform.isAndroid) {
    // Define a custom folder within the public Downloads folder.
    Directory customDownloadDir =
        Directory('/storage/emulated/0/Download/Zekr Mobarak');
    // Create the directory if it does not exist.
    if (!await customDownloadDir.exists()) {
      await customDownloadDir.create(recursive: true);
    }
    return customDownloadDir;
  } else {
    // For non-Android platforms, use the app's documents directory.
    return await getApplicationDocumentsDirectory();
  }
}

/// Downloads the audio file from [audioUrl] with the given [title]
/// and saves it in the custom download directory.
Future<void> downloadAudio(
    String audioUrl, String title, BuildContext context) async {
  // Request storage permission.
  if (await requestPermission(Permission.storage)) {
    // Get the custom download directory.
    Directory? downloadsDirectory = await getCustomDownloadDirectory();

    if (downloadsDirectory != null) {
      // Construct the file name and file path.
      String fileName = "$title.mp3";
      String filePath = "${downloadsDirectory.path}/$fileName";

      Dio dio = Dio();
      // Variable to track the last time a progress update was shown.
      DateTime lastProgressUpdate = DateTime.now();

      try {
        // Download the file using Dio.
        await dio.download(
          audioUrl,
          filePath,
          onReceiveProgress: (received, total) {
            // Get the current time.
            final currentTime = DateTime.now();
            // Update progress only every 3 seconds.
            if (currentTime.difference(lastProgressUpdate).inSeconds >= 3) {
              lastProgressUpdate = currentTime;
              if (total != -1) {
                // Calculate the progress percentage.
                String progress = (received / total * 100).toStringAsFixed(0);
                // Display the progress message.
                showMessage("جاري التحميل: $progress%");
              }
            }
          },
        );

        // Notify the user that the download is complete.
        showMessage('$fileName متاحة الآن في$filePath');
        // Optionally, trigger a media scan so the file appears in galleries/file managers.
        await scanFile(filePath);
      } catch (e) {
        log("فشل التحميل: $e");
      }
    } else {
      showMessage('فشل الحصول على مكان التنزيل.');
    }
  } else {
    showMessage('تم رفض الوصول للتخزين الداخلي');
  }
}

Future<void> scanFile(String filePath) async {
  try {
    await _mediaScannerChannel.invokeMethod('scanFile', {'filePath': filePath});
    debugPrint("Scanning file: $filePath");
  } on PlatformException catch (e) {
    debugPrint("Error scanning file: ${e.message}");
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

String normalizeArabic(String text) {
  String withoutTashkeel = text.replaceAll(RegExp(r'[ًٌٍَُِّْۡ]'), '');
  String normalized = withoutTashkeel
      .replaceAll(RegExp(r'[أإٱآٰ]'), 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll('ة', 'ه')
      .trim(); // Trim spaces
  return normalized;
}

void showOfflineMessage() {
  showMessage('لا يتوفر اتصال بالانترنت.');
}
