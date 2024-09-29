import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

void initializeAudioPlayer(AudioPlayer audioPlayer, Function(Duration) setTotalDuration, Function(Duration) setCurrentDuration, Function(bool) setIsPlaying) {
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

Future<void> togglePlayPause(AudioPlayer audioPlayer, bool isPlaying, String audioUrl, Function(bool) setIsPlaying) async {
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

void forward(AudioPlayer audioPlayer) {
  adjustSpeed(audioPlayer, 1.25);
}

void backward(AudioPlayer audioPlayer) {
  adjustSpeed(audioPlayer, 0.75);
}

Future<void> shareAudio(String audioUrl) async {
  Share.share(audioUrl);
}
 Future<void> downloadDarsAudio(
      String audioUrl, String title, BuildContext context) async {
    if (await requestPermission(Permission.storage)) {
      final dir = await getExternalStorageDirectory();
      if (dir != null) {
        String fileName = "$title.mp3";
        String filePath = "${dir.path}/$fileName";

        Dio dio = Dio();
        await dio.download(audioUrl, filePath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloaded $fileName')),
        );
      }
    }
  }

Future<void> downloadAudio(String audioUrl, int surahIndex, BuildContext context) async {
  if (await requestPermission(Permission.storage)) {
    final dir = await getExternalStorageDirectory();
    if (dir != null) {
      String fileName = "surah_${surahIndex + 1}.mp3";
      String filePath = "${dir.path}/$fileName";

      Dio dio = Dio();
      await dio.download(audioUrl, filePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Downloaded $fileName')),
      );
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
  Function(bool) setIsPlaying
) async {
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
