import 'dart:developer';

import 'package:flutter/material.dart';

class VerseButtons extends StatelessWidget {
  const VerseButtons({
    super.key,
    required this.currentSurahIndex,
    required this.highlightedVerse,
  });

  final int currentSurahIndex;
  final int? highlightedVerse;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            log('Surah: $currentSurahIndex, Verse: $highlightedVerse');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            shadowColor: Colors.black54,
            elevation: 4,
          ),
          child: const Text('Print Info'),
        ),
        ElevatedButton(
          onPressed: () {
            log('Surah: $currentSurahIndex, Verse: $highlightedVerse');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            shadowColor: Colors.black54,
            elevation: 4,
          ),
          child: const Text('Print Info'),
        ),
      ],
    );
  }
}
