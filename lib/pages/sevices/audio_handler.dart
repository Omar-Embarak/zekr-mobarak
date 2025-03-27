// audio_player_handler.dart

import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:azkar_app/model/audio_model.dart';
import 'package:just_audio/just_audio.dart';
import '../../methods.dart';

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  // Instance of the Just Audio player.
  final AudioPlayer _player = AudioPlayer();

  // Playlist fields – holds the list of AudioModel objects and current index.
  static List<AudioModel> currentPlaylist = [];
  int currentIndex = 0;

  AudioPlayerHandler() {
    // Listen for playback events and update the playbackState stream (used by system notifications).
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
  }

  // Map Just Audio's ProcessingState to AudioService's AudioProcessingState.
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

  // Basic playback control methods.
  @override
  Future<void> play() => _player.play();
  @override
  Future<void> pause() => _player.pause();
  @override
  Future<void> stop() => _player.stop();
  @override
  Future<void> seek(Duration position) => _player.seek(position);

  // Expose streams for playback position and duration.
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  /// Toggles play/pause for a track. If a different track is requested,
  /// and a playlist is set, we simply seek to the desired index without reinitializing the playlist.
  Future<void> togglePlayPause({
    required bool isPlaying,
    required String audioUrl,
    required String albumName,
    required String title,
    required int index,
    required int playlistIndex, // The index in the playlist.
    required Function(bool) setIsPlaying,
    void Function()? onAudioTap,
  }) async {
    // Check if the requested URL is accessible.
    if (!await isUrlAccessible(audioUrl)) {
      showMessage('الملف الصوتي غير متاح.');
      return;
    }
    // If the current media item does not match the requested one...
    if (mediaItem.value?.id != audioUrl) {
      currentIndex = playlistIndex; // Update our current playlist index.
      showMessage("جاري التشغيل..");

      // Create a new media item using the provided metadata.
      final newMediaItem = MediaItem(
          id: audioUrl,
          album: albumName,
          title: title,
          artUri: Uri.parse('assets/images/ic_launcher.png'),
          extras: {'index': currentIndex});
      // Immediately update the media item stream.
      mediaItem.add(newMediaItem);

      // If a playlist is already set, simply seek to the track's index.
      if (currentPlaylist.isNotEmpty) {
        await _player.seek(Duration.zero, index: playlistIndex);
      } else {
        // Otherwise, set the audio source as a single track.
        await _player.setAudioSource(
          AudioSource.uri(Uri.parse(audioUrl), tag: newMediaItem),
        );
      }

      await play(); // Start playback.
      if (onAudioTap != null) onAudioTap();
      setIsPlaying(true);
    } else {
      // If the same track is tapped again, toggle play/pause.
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

  // Increase playback speed.
  Future<void> increaseSpeed() async {
    double currentSpeed = _player.speed;
    double newSpeed = (currentSpeed + 0.25).clamp(0.5, 2.0);
    await _player.setSpeed(newSpeed);
    showMessage("Speed increased to ${newSpeed.toStringAsFixed(2)}x");
  }

  // Decrease playback speed.
  Future<void> decreaseSpeed() async {
    double currentSpeed = _player.speed;
    double newSpeed = (currentSpeed - 0.25).clamp(0.5, 2.0);
    await _player.setSpeed(newSpeed);
    showMessage("Speed decreased to ${newSpeed.toStringAsFixed(2)}x");
  }

  /// Sets up a concatenated playlist for continuous playback using a list of AudioModel.
  Future<void> setAudioSourceWithPlaylist({
    required List<AudioModel> playlist,
    required int index, // Starting index for playback.
    required String album,
    required String title,
    Uri? artUri,
  }) async {
    // Save the playlist and current index.
    currentPlaylist = playlist;
    currentIndex = index;

    // Build a concatenating audio source from the list of AudioModel objects.
    List<AudioSource> sources = playlist.map((audioModel) {
      return AudioSource.uri(Uri.parse(audioModel.audioURL));
    }).toList();
    final concatenatingAudioSource =
        ConcatenatingAudioSource(children: sources);

    // Set the audio source with the concatenated playlist, starting at the given index.
    await _player.setAudioSource(concatenatingAudioSource, initialIndex: index);

    // Create and add a media item with metadata from the AudioModel.
    final newMediaItem = MediaItem(
        id: playlist[index].audioURL,
        album: album,
        title: title,
        artUri: artUri ?? Uri.parse('assets/images/ic_launcher.png'),
        extras: {'index': currentIndex});
    mediaItem.add(newMediaItem);
  }

  // Skip to the next track in the playlist.
  @override
  Future<void> skipToNext() async {
    log("${currentIndex}+ in audio handler");
    showMessage("جاري التخطي للمقطع السابق");
    await _player.seekToNext();


    currentIndex = _player.currentIndex ?? currentIndex;
    mediaItem.add(MediaItem(
        id: currentPlaylist[currentIndex].audioURL,
        album: mediaItem.value?.album ?? '',
        title: currentPlaylist[currentIndex].title,
        artUri: Uri.parse('assets/images/ic_launcher.png'),
        extras: {'index': currentIndex}));
  }

  @override
  Future<void> skipToPrevious() async {
    showMessage("جاري التخطي للمقطع التالي");

    await _player.seekToPrevious();

    currentIndex = _player.currentIndex ?? currentIndex;
    mediaItem.add(MediaItem(
        id: currentPlaylist[currentIndex].audioURL,
        album: mediaItem.value?.album ?? '',
        title: currentPlaylist[currentIndex].title,
        artUri: Uri.parse('assets/images/ic_launcher.png'),
        extras: {'index': currentIndex}));
  }

  // For rewind and fast-forward, adjust playback speed.
  @override
  Future<void> rewind() async {
    await decreaseSpeed();
  }

  @override
  Future<void> fastForward() async {
    await increaseSpeed();
  }
}
