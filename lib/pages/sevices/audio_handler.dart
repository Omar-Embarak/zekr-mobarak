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
            MediaControl.fastForward,
          ],
          systemActions: {MediaAction.seek},
          // Update indices to match new controls array.
          androidCompactActionIndices: const [0, 1, 2],
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

  // Increase playback speed by 0.25, capped at 2.0.
  Future<void> increaseSpeed() async {
    double currentSpeed = _player.speed;
    double newSpeed = (currentSpeed + 0.25).clamp(0.5, 2.0);
    await _player.setSpeed(newSpeed);
    showMessage("Speed increased to ${newSpeed.toStringAsFixed(2)}x");
  }

  // Decrease playback speed by 0.25, with a minimum of 0.5.
  Future<void> decreaseSpeed() async {
    double currentSpeed = _player.speed;
    double newSpeed = (currentSpeed - 0.25).clamp(0.5, 2.0);
    await _player.setSpeed(newSpeed);
    showMessage("Speed decreased to ${newSpeed.toStringAsFixed(2)}x");
  }

  // Override fastForward to increase speed via notification button.
  @override
  Future<void> fastForward() async {
    //the functions is swaped to sync the button that in the item
    await decreaseSpeed();
  }

  // Override rewind to decrease speed via notification button.
  @override
  Future<void> rewind() async {
    //the functions is swaped to sync the button that in the item


    await increaseSpeed();
  }
}
