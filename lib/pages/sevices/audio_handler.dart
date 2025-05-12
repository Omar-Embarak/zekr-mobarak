// audio_player_handler.dart

import 'package:audio_service/audio_service.dart';
import 'package:azkar_app/model/audio_model.dart';
// import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../methods.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  // Instance of the Just Audio player.
  final AudioPlayer _player = AudioPlayer();
// final mediaItem = ValueNotifier<MediaItem?>(null);

  // Playlist fields – holds the list of AudioModel objects and current index.
  static List<AudioModel> currentPlaylist = [];
  int currentIndex = 0;

  AudioPlayerHandler() {
    // Listen for playback events and update the playbackState stream (used by system notifications).
    _player.playbackEventStream
        .throttleTime(const Duration(milliseconds: 100))
        .listen((event) {
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
    _player.currentIndexStream.listen((index) {
      if (index != null && index >= 0 && index < currentPlaylist.length) {
        currentIndex = index;
        _updateMediaItem();

        _updatePlaybackState(); // Immediate update
      }
    });
  }
  void _updateMediaItem() {
    if (currentIndex >= 0 && currentIndex < currentPlaylist.length) {
      final audioModel = currentPlaylist[currentIndex];
      mediaItem.add(MediaItem(
        id: audioModel.audioURL,
        album: audioModel.album,
        title: audioModel.title,
        artUri: Uri.parse('assets/images/ic_notification.png'),
        extras: {'index': currentIndex,'URL':audioModel.audioURL})
);
    }
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

  void _updatePlaybackState() {
    final playing = _player.playing;
    final processingState = _mapProcessingState(_player.processingState);
    playbackState.add(PlaybackState(
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
    ));
  }

  @override
  Future<void> play() async {
    await _player.play();
    // Manually update the playback state in case of any discrepancies
    _updatePlaybackState();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
    _updatePlaybackState(); // Update the playback state on pause
  }

  @override
  Future<void> stop() async {
    await _player.stop(); // Ensure stopping is called properly
    _updatePlaybackState(); // update the state after stopping
  }

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
    required int playlistIndex,
    required Function(bool) setIsPlaying,
    void Function()? onAudioTap,
  }) async {
    if (!await isUrlAccessible(audioUrl)) {
      showMessage('الملف الصوتي غير متاح.');
      return;
    }

    if (mediaItem.value?.id != audioUrl) {
      currentIndex = playlistIndex;
      // showMessage("جاري التشغيل..");

      final newMediaItem = MediaItem(
        id: audioUrl,
        album: albumName,
        title: title,
        artUri: Uri.parse('asset:///assets/images/ic_notification.png.png'),
        extras: {'index': currentIndex},
      );

      mediaItem.add(newMediaItem);

      if (currentPlaylist.isNotEmpty) {
        await _player.seek(Duration.zero, index: playlistIndex);
      } else {
        await _player.setAudioSource(
          AudioSource.uri(Uri.parse(audioUrl), tag: newMediaItem),
        );
      }

      await play();
      if (onAudioTap != null) onAudioTap();
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
    _updatePlaybackState(); // Immediate update
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

  Future<void> setAudioSourceWithPlaylist({
    required List<AudioModel> playlist,
    required int index,
    required String album,
    required String title,
    Uri? artUri,
  }) async {
    currentPlaylist = playlist;
    currentIndex = index;

    List<AudioSource> sources = playlist.map((audioModel) {
      return AudioSource.uri(Uri.parse(audioModel.audioURL));
    }).toList();

    final concatenatingAudioSource =
        ConcatenatingAudioSource(children: sources);

    // Set audio source without auto-playing
    await _player.setAudioSource(
      concatenatingAudioSource,
      initialIndex: index,
      preload: false, // Don't preload audio
      initialPosition: Duration.zero, // Don't auto-play
    );

    final newMediaItem = MediaItem(
        id: playlist[index].audioURL,
        album: album,
        title: title,
        artUri: artUri ?? Uri.parse('assets/images/ic_launcher.png'),
        extras: {'index': currentIndex,'URL':playlist[index].audioURL});
    mediaItem.add(newMediaItem);

    // Ensure player is paused initially
    await _player.pause();
  }

  // Skip to the next track in the playlist.
  @override
  Future<void> skipToNext() async {
    // showMessage("جاري التخطي للمقطع السابق");
    await _player.seekToNext();

    // currentIndex = _player.currentIndex ?? currentIndex;
    // mediaItem.add(MediaItem(
    //     id: currentPlaylist[currentIndex].audioURL,
    //     album: mediaItem.value?.album ?? '',
    //     title: currentPlaylist[currentIndex].title,
    //     //artUri: Uri.parse('assets/images/ic_launcher.png'),
    //     extras: {'index': currentIndex}));
  }

  @override
  Future<void> skipToPrevious() async {
    // showMessage("جاري التخطي للمقطع التالي");

    await _player.seekToPrevious();

    // currentIndex = _player.currentIndex ?? currentIndex;
    // mediaItem.add(MediaItem(
    //     id: currentPlaylist[currentIndex].audioURL,
    //     album: mediaItem.value?.album ?? '',
    //     title: currentPlaylist[currentIndex].title,
    //     //artUri: Uri.parse('assets/images/ic_launcher.png'),
    //     extras: {'index': currentIndex}));
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
