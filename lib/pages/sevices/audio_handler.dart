// audio_player_handler.dart
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import '../../methods.dart';

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayerHandler() {
    _player.playbackEventStream.listen((event) {
      final playing = _player.playing;
      final processingState = _mapProcessingState(_player.processingState);
      playbackState.add(
        PlaybackState(
          controls: [
            MediaControl.rewind,
            playing ? MediaControl.pause : MediaControl.play,
            MediaControl.stop,
            MediaControl.fastForward,
          ],
          systemActions: {MediaAction.seek},
          androidCompactActionIndices: const [0, 1, 3],
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
      case ProcessingState.idle: return AudioProcessingState.idle;
      case ProcessingState.loading: return AudioProcessingState.loading;
      case ProcessingState.buffering: return AudioProcessingState.buffering;
      case ProcessingState.ready: return AudioProcessingState.ready;
      case ProcessingState.completed: return AudioProcessingState.completed;
      default: return AudioProcessingState.idle;
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

  Future<void> setAudioSourceWithMetadata({
    required String audioUrl,
    required String reciterName,
    required String surahName,
    Uri? artUri,
  }) async {
    final newMediaItem = MediaItem(
      id: audioUrl,
      album: reciterName,
      title: surahName,
      artUri: artUri ?? Uri.parse('assets/images/ic_launcher.png'),
    );
    mediaItem.add(newMediaItem);
    await _player.setAudioSource(
      AudioSource.uri(Uri.parse(audioUrl), tag: newMediaItem),
    );
  }

  Future<void> togglePlayPause({
    required bool isPlaying,
    required String audioUrl,
    required String reciterName,
    required String surahName,
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
}
