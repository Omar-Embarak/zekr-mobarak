// import 'package:audioplayers/audioplayers.dart';

// class AudioManager {
//   // Singleton implementation
//   static final AudioManager _instance = AudioManager._internal();
//   factory AudioManager() => _instance;
//   AudioManager._internal();

//   final AudioPlayer _audioPlayer = AudioPlayer();
//   String? _currentAudioUrl; // Tracks the currently playing URL

//   AudioPlayer get audioPlayer => _audioPlayer;

//   AudioManager() {
//     // Listener for playback completion
//     _audioPlayer.onPlayerComplete.listen((event) {
//       _currentAudioUrl = null;
//     });

//     // Listener for errors
//     _audioPlayer.onPlayerError.listen((event) {
//       _currentAudioUrl = null;
//     });
//   }

//   /// Toggles between play and pause for the given [audioUrl].
//   Future<void> togglePlayPause(String audioUrl) async {
//     try {
//       if (_currentAudioUrl == audioUrl && _audioPlayer.state == PlayerState.playing) {
//         await _audioPlayer.pause(); // Pause if the same audio is playing
//       } else {
//         await _audioPlayer.stop(); // Stop any current playback
//         _currentAudioUrl = audioUrl;
//         await _audioPlayer.play(UrlSource(audioUrl)); // Play the new audio
//       }
//     } catch (e) {
//       print('Error in togglePlayPause: $e');
//     }
//   }

//   /// Stops the current playback.
//   Future<void> stop() async {
//     try {
//       await _audioPlayer.stop();
//       _currentAudioUrl = null;
//     } catch (e) {
//       print('Error in stop: $e');
//     }
//   }

//   /// Checks if the given [audioUrl] is currently playing.
//   bool isPlaying(String audioUrl) {
//     return _audioPlayer.state == PlayerState.playing && _currentAudioUrl == audioUrl;
//   }

//   /// Sets the volume for the player (0.0 to 1.0).
//   Future<void> setVolume(double volume) async {
//     try {
//       await _audioPlayer.setVolume(volume);
//     } catch (e) {
//       print('Error in setVolume: $e');
//     }
//   }
// }
