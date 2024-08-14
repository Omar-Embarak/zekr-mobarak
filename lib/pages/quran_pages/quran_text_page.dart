import 'package:flutter/material.dart';

import 'package:quran/quran.dart' as quran;
import 'package:flutter_tts/flutter_tts.dart';

import '../../constants/colors.dart';

class SurahPage extends StatelessWidget {
  final int surahIndex;

  const SurahPage({super.key, required this.surahIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        title: Text(quran.getSurahNameArabic(surahIndex)),
        backgroundColor: AppColors.kPrimaryColor,
      ),
      body: PageView.builder(
        itemCount: quran.getVerseCount(surahIndex),
        controller: PageController(),
        itemBuilder: (context, index) {
          final verseText = quran.getVerse(surahIndex, index + 1);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '$verseText [${index + 1}]',
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 24,
                  height: 2.0, // جعل الآيات بجانب بعضها البعض
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class QuranTextScreen extends StatefulWidget {
  final int surahIndex;
  final int ayahIndex;

  const QuranTextScreen(
      {super.key, required this.surahIndex, required this.ayahIndex});

  @override
  QuranTextScreenState createState() => QuranTextScreenState();
}

class QuranTextScreenState extends State<QuranTextScreen> {
  late int _currentSurahIndex;
  late int _currentAyahIndex;
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _currentSurahIndex = widget.surahIndex;
    _currentAyahIndex = widget.ayahIndex;
  }

  void _nextAyah() {
    setState(() {
      if (_currentAyahIndex < quran.getVerseCount(_currentSurahIndex)) {
        _currentAyahIndex++;
      } else if (_currentSurahIndex < quran.totalSurahCount) {
        _currentSurahIndex++;
        _currentAyahIndex = 1;
      }
    });
  }

  void _previousAyah() {
    setState(() {
      if (_currentAyahIndex > 1) {
        _currentAyahIndex--;
      } else if (_currentSurahIndex > 1) {
        _currentSurahIndex--;
        _currentAyahIndex = quran.getVerseCount(_currentSurahIndex);
      }
    });
  }

  Future<void> _playVerse() async {
    await _flutterTts
        .speak(quran.getVerse(_currentSurahIndex, _currentAyahIndex));
  }

  @override
  Widget build(BuildContext context) {
    final String verseText =
        quran.getVerse(_currentSurahIndex, _currentAyahIndex);

    return Scaffold(
      appBar: AppBar(
        title: Text(quran.getSurahNameArabic(_currentSurahIndex)),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          if (details.primaryVelocity! > 0) {
            _previousAyah();
          } else if (details.primaryVelocity! < 0) {
            _nextAyah();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    '$verseText [$_currentAyahIndex]',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _playVerse,
                child: const Text('تشغيل الآية'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

