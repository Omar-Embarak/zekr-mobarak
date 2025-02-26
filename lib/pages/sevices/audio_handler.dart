// audio_player_handler.dart
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import '../../methods.dart';
import 'package:quran/quran.dart' as quran; // for surah name lookup

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  // Fields to track the current surah and reciter base URL.
  int? currentSurahIndex;
  String? currentReciterUrl;

  AudioPlayerHandler() {
    _player.playbackEventStream.listen((event) {
      final playing = _player.playing;
      final processingState = _mapProcessingState(_player.processingState);
      playbackState.add(
        PlaybackState(
          controls: [
            MediaControl.skipToPrevious, // navigation previous surah
            MediaControl.rewind,         // speed down
            playing ? MediaControl.pause : MediaControl.play,
            MediaControl.fastForward,    // speed up
            MediaControl.skipToNext,     // navigation next surah
          ],
          systemActions: {MediaAction.seek},
          // In compact view, show the middle three buttons (speed & play/pause)
          androidCompactActionIndices: const [1, 2, 3],
          processingState: processingState,
          playing: playing,
          updatePosition: _player.position,
          bufferedPosition: _player.bufferedPosition,
          speed: _player.speed,
        ),
      );
    });
  }

  AudioProcessingState _mapProcessingState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        return AudioProcessingState.idle;
    }
  }

  @override
  Future<void> play() => _player.play();
  @override
  Future<void> pause() => _player.pause();
  @override
  Future<void> stop() => _player.stop();
  @override
  Future<void> seek(Duration position) => _player.seek(position);

  // Expose streams for position and duration.
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  /// Sets the audio source while updating current surah info.
  Future<void> setAudioSourceWithMetadata({
    required String audioUrl,
    required String reciterName,
    required String surahName,
    required int surahIndex,
    required String reciterUrl,
    Uri? artUri,
  }) async {
    // Update global current surah info.
    currentSurahIndex = surahIndex;
    currentReciterUrl = reciterUrl;
    final newMediaItem = MediaItem(
      id: audioUrl,
      album: reciterName,
      title: surahName,
      extras: {'surahIndex': surahIndex},
      artUri: artUri ?? Uri.parse('assets/images/ic_launcher.png'),
    );
    mediaItem.add(newMediaItem);
    await _player.setAudioSource(
      AudioSource.uri(Uri.parse(audioUrl), tag: newMediaItem),
    );
  }

  /// Toggle play/pause; if a different surah is requested, load it.
  Future<void> togglePlayPause({
    required bool isPlaying,
    required String audioUrl,
    required String reciterName,
    required String surahName,
    required int surahIndex,
    required String reciterUrl,
    required Function(bool) setIsPlaying,
    void Function()? onSurahTap,
  }) async {
    if (!await isUrlAccessible(audioUrl)) {
      showMessage('الملف الصوتي غير متاح.');
      return;
    }
    if (mediaItem.value?.id != audioUrl) {
      showMessage("جاري التشغيل..");
      await setAudioSourceWithMetadata(
        audioUrl: audioUrl,
        reciterName: reciterName,
        surahName: surahName,
        surahIndex: surahIndex,
        reciterUrl: reciterUrl,
      );
      await play();
      if (onSurahTap != null) onSurahTap();
      setIsPlaying(true);
    } else {
      if (isPlaying) {
        showMessage("تم ايقاف التشغيل");
        await pause();
        setIsPlaying(false);
      } else {
        showMessage("جاري التشغيل..");
        await play();
        setIsPlaying(true);
      }
    }
  }

  // Speed adjustment methods.
  Future<void> increaseSpeed() async {
    double currentSpeed = _player.speed;
    double newSpeed = (currentSpeed + 0.25).clamp(0.5, 2.0);
    await _player.setSpeed(newSpeed);
    showMessage("Speed increased to ${newSpeed.toStringAsFixed(2)}x");
  }

  Future<void> decreaseSpeed() async {
    double currentSpeed = _player.speed;
    double newSpeed = (currentSpeed - 0.25).clamp(0.5, 2.0);
    await _player.setSpeed(newSpeed);
    showMessage("Speed decreased to ${newSpeed.toStringAsFixed(2)}x");
  }

  // --- Notification button overrides ---

  // Navigation: previous surah.
  @override
  Future<void> skipToPrevious() async {
    if (currentSurahIndex == null || currentReciterUrl == null) return;
    int prevIndex = currentSurahIndex! - 1;
    if (prevIndex < 0) {
      showMessage("لا يوجد سورة سابقة");
      return;
    }
    String prevAudioUrl = _buildAudioUrl(prevIndex, currentReciterUrl!);
    await togglePlayPause(
      isPlaying: false,
      audioUrl: prevAudioUrl,
      reciterName: mediaItem.value?.album ?? '',
      surahName: quran.getSurahNameArabic(prevIndex + 1),
      surahIndex: prevIndex,
      reciterUrl: currentReciterUrl!,
      setIsPlaying: (_) {},
      onSurahTap: () {},
    );
  }

  // Navigation: next surah.
  @override
  Future<void> skipToNext() async {
    if (currentSurahIndex == null || currentReciterUrl == null) return;
    int nextIndex = currentSurahIndex! + 1;
    if (nextIndex >= 114) {
      showMessage("لا يوجد سورة تالية");
      return;
    }
    String nextAudioUrl = _buildAudioUrl(nextIndex, currentReciterUrl!);
    await togglePlayPause(
      isPlaying: false,
      audioUrl: nextAudioUrl,
      reciterName: mediaItem.value?.album ?? '',
      surahName: quran.getSurahNameArabic(nextIndex + 1),
      surahIndex: nextIndex,
      reciterUrl: currentReciterUrl!,
      setIsPlaying: (_) {},
      onSurahTap: () {},
    );
  }

  // Speed down via notification.
  @override
  Future<void> rewind() async {
    await decreaseSpeed();
  }

  // Speed up via notification.
  @override
  Future<void> fastForward() async {
    await increaseSpeed();
  }

  String _buildAudioUrl(int surahIndex, String reciterUrl) {
    // Adjust according to zero-padding option.
    // Example:
    // return '$reciterUrl${(surahIndex + 1).toString().padLeft(3, '0')}.mp3';
    return '$reciterUrl${surahIndex + 1}.mp3';
  }
}
