import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

import '../methods.dart';

class VerseButtons extends StatefulWidget {
  const VerseButtons({
    super.key,
    required this.currentSurahIndex,
    required this.highlightedVerse,
  });

  final int currentSurahIndex;
  final int highlightedVerse;

  @override
  State<VerseButtons> createState() => _VerseButtonsState();
}

class _VerseButtonsState extends State<VerseButtons> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isSoundPlaying = false;
  late ConnectivityResult _connectivityStatus;
  late final StreamSubscription<PlayerState> _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();

    // Listen to player state changes
    _playerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isSoundPlaying = state == PlayerState.playing;
        });

        if (state == PlayerState.playing) {
          showMessage('جاري تشغيل الاية...');
        }
      }
    });
  }

  @override
  void dispose() {
    // Stop audio player and release resources
    _audioPlayer.stop();
    _audioPlayer.dispose();

    // Cancel the listener subscription
    _playerStateSubscription.cancel();

    super.dispose();
  }

  Future<void> _checkInternetConnection() async {
    final List<ConnectivityResult> connectivityResults =
        await Connectivity().checkConnectivity();

    if (mounted) {
      setState(() {
        _connectivityStatus =
            connectivityResults.contains(ConnectivityResult.none)
                ? ConnectivityResult.none
                : connectivityResults.first;
      });
    }
  }

  void togglePlayPause(String audioUrl) async {
    if (isSoundPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(audioUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.lightGreenAccent.withOpacity(0.6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                _checkInternetConnection();
                if (_connectivityStatus == ConnectivityResult.none) {
                  showMessage('لا يتوفر اتصال بالانترنت');
                } else {
                  togglePlayPause(quran.getAudioURLByVerse(
                    widget.currentSurahIndex,
                    widget.highlightedVerse,
                  ));
                }
              },
              icon:
                  Icon(isSoundPlaying ? Icons.pause_rounded : Icons.play_arrow),
              color: Colors.green,
              iconSize: 28,
              tooltip: 'تشغيل الاية',
            ),
            IconButton(
              onPressed: () {
                showTafseer(
                  surahNumber: widget.currentSurahIndex,
                  verseNumber: widget.highlightedVerse,
                  context: context,
                );
              },
              icon: const Icon(Icons.tips_and_updates_rounded),
              color: Colors.green,
              iconSize: 28,
              tooltip: 'تفسير الاية',
            ),
            IconButton(
              onPressed: () {
                shareAudio(quran.getAudioURLByVerse(
                  widget.currentSurahIndex,
                  widget.highlightedVerse,
                ));
              },
              icon: const Icon(Icons.share),
              color: Colors.green,
              iconSize: 28,
              tooltip: 'مشاركة',
            ),
            IconButton(
              onPressed: () {
                _checkInternetConnection();
                if (_connectivityStatus == ConnectivityResult.none) {
                  showMessage('لا يتوفر اتصال بالانترنت.');
                } else {
                  downloadAudio(
                    quran.getAudioURLByVerse(
                      widget.currentSurahIndex,
                      widget.highlightedVerse,
                    ),
                    quran.getSurahNameArabic(widget.currentSurahIndex),
                    context,
                  );
                }
              },
              icon: const Icon(Icons.download_rounded),
              color: Colors.green,
              iconSize: 28,
              tooltip: 'تحميل',
            ),
          ],
        ),
      ),
    );
  }
}
