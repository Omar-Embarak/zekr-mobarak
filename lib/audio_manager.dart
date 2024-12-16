import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioState {
  static final ValueNotifier<String?> currentPlayingAudio = ValueNotifier(null);
  static final AudioPlayer audioPlayer = AudioPlayer(); // Singleton instance
  
}
