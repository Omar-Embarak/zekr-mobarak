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
  bool useZeroPadding = false; // Add this flag if applicable

  // New playlist fields
  static List<String> currentPlaylist = [];
  int currentIndex = 0;

  AudioPlayerHandler() {
    // Existing listener for playback events
    _player.playbackEventStream.listen((event) {
      final playing = _player.playing;
      final processingState = _mapProcessingState(_player.processingState);
      playbackState.add(
        PlaybackState(
          controls: [
            MediaControl.skipToPrevious,
            MediaControl.rewind,
            playing ? MediaControl.pause : MediaControl.play,
            MediaControl.fastForward,
            MediaControl.skipToNext,
          ],
          systemActions: {MediaAction.seek},
          androidCompactActionIndices: const [1, 2, 3],
          processingState: processingState,
          playing: playing,
          updatePosition: _player.position,
          bufferedPosition: _player.bufferedPosition,
          speed: _player.speed,
        ),
      );
    });

    // New: Listen for the completed state to auto-skip to the next surah.
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        skipToNext();
      }
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
    bool zeroPadding = false,
    Uri? artUri,
  }) async {
    // Update global info.
    currentSurahIndex = surahIndex;
    currentReciterUrl = reciterUrl; // Make sure this is always set.
    useZeroPadding = zeroPadding;

    final newMediaItem = MediaItem(
      id: audioUrl,
      album: reciterName,
      title: surahName,
      extras: {
        'surahIndex': surahIndex,
        'reciterUrl': reciterUrl, // Save reciterUrl here.
      },
      artUri: artUri ?? Uri.parse('assets/images/ic_launcher.png'),
    );

    // Update media item stream ASAP for quick UI updates.
    mediaItem.add(newMediaItem);

    // Load the audio source.
    await _player.setAudioSource(
      AudioSource.uri(Uri.parse(audioUrl), tag: newMediaItem),
    );
  }

  Future<void> togglePlayPause({
    required bool isPlaying,
    required String audioUrl,
    required String reciterName,
    required String surahName,
    required int surahIndex,
    required int playlistIndex, // New parameter for the playlist index
    required String reciterUrl,
    required Function(bool) setIsPlaying,
    void Function()? onSurahTap,
    bool zeroPadding = false,
  }) async {
    // Check if the requested audio is accessible
    if (!await isUrlAccessible(audioUrl)) {
      showMessage('الملف الصوتي غير متاح.');
      return;
    }
    if (mediaItem.value?.id != audioUrl) {
      currentIndex = playlistIndex; // update index
      showMessage("جاري التشغيل..");

      // Create new media item and update streams immediately.
      final newMediaItem = MediaItem(
        id: audioUrl,
        album: reciterName,
        title: surahName,
        extras: {'surahIndex': surahIndex},
        artUri: Uri.parse('assets/images/ic_launcher.png'),
      );
      mediaItem.add(newMediaItem);

      // Immediately update playback state so notifications react fast.
      playbackState.add(
        PlaybackState(
          controls: [
            MediaControl.skipToPrevious,
            MediaControl.rewind,
            MediaControl.play,
            MediaControl.fastForward,
            MediaControl.skipToNext,
          ],
          systemActions: {MediaAction.seek},
          androidCompactActionIndices: const [1, 2, 3],
          processingState: AudioProcessingState.loading,
          playing: false,
          updatePosition: _player.position,
          bufferedPosition: _player.bufferedPosition,
          speed: _player.speed,
        ),
      );

      // Instead of awaiting heavy operations, fire-and-forget.
      _player
          .setAudioSource(
        AudioSource.uri(Uri.parse(audioUrl), tag: newMediaItem),
      )
          .then((_) async {
        await play();
        if (onSurahTap != null) onSurahTap();
        setIsPlaying(true);
        // Optionally, update playback state after play starts.
      });
    } else {
      // Toggle play/pause if the same surah is tapped again.
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

  Future<void> setAudioSourceWithPlaylist({
    required List<String> playlist,
    required int index,
    required String reciterName,
    required String surahName,
    required String reciterUrl,
    bool zeroPadding = false,
    Uri? artUri,
  }) async {
    currentPlaylist = playlist;
    currentIndex = index;

    // Build a concatenating audio source from the playlist.
    List<AudioSource> sources = playlist.map((url) {
      return AudioSource.uri(Uri.parse(url));
    }).toList();
    final concatenatingAudioSource =
        ConcatenatingAudioSource(children: sources);

    // Set the concatenating audio source once.
    await _player.setAudioSource(concatenatingAudioSource, initialIndex: index);

    // Update the media item stream immediately.
    final firstUrl = playlist[index];
    final newMediaItem = MediaItem(
      id: firstUrl,
      album: reciterName,
      title: surahName,
      extras: {
        'surahIndex': index,
        'reciterUrl': reciterUrl,
      },
      artUri: artUri ?? Uri.parse('assets/images/ic_launcher.png'),
    );
    mediaItem.add(newMediaItem);
  }

  @override
  Future<void> skipToNext() async {
    await _player.seekToNext();
    currentIndex = _player.currentIndex ?? currentIndex;
    String nextAudioUrl = currentPlaylist[currentIndex];
    final newMediaItem = MediaItem(
      id: nextAudioUrl,
      album: mediaItem.value?.album ?? '',
      title: quran.getSurahNameArabic(currentIndex + 1),
      extras: {'surahIndex': currentIndex},
      artUri: Uri.parse('assets/images/ic_launcher.png'),
    );
    mediaItem.add(newMediaItem);
  }

  @override
  Future<void> skipToPrevious() async {
    await _player.seekToPrevious();
    currentIndex = _player.currentIndex ?? currentIndex;
    String prevAudioUrl = currentPlaylist[currentIndex];
    final newMediaItem = MediaItem(
      id: prevAudioUrl,
      album: mediaItem.value?.album ?? '',
      title: quran.getSurahNameArabic(currentIndex + 1),
      extras: {'surahIndex': currentIndex},
      artUri: Uri.parse('assets/images/ic_launcher.png'),
    );
    mediaItem.add(newMediaItem);
  }

  @override
  Future<void> rewind() async {
    await decreaseSpeed();
  }

  @override
  Future<void> fastForward() async {
    await increaseSpeed();
  }
}
