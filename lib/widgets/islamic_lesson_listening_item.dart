// import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:azkar_app/model/audio_model.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../methods.dart';
import '../../utils/app_images.dart';
import '../main.dart';
import '../model/fav_dars_model.dart';
import '../pages/islamic_lessons_pages/fav_islamic_lessons_provider.dart';
import '../pages/sevices/audio_handler.dart';

class LessonListeningItem extends StatefulWidget {
  final int lessonIndex;
  final int totalLessons;
  final String audioUrl;
  final String title;
  final String description;
  final String Function(int index) getAudioUrl;
  final List<AudioModel> playlist;
  const LessonListeningItem({
    super.key,
    required this.lessonIndex,
    required this.totalLessons,
    required this.audioUrl,
    required this.title,
    required this.description,
    required this.getAudioUrl,
    required this.playlist,
  });

  @override
  State<LessonListeningItem> createState() => _LessonListeningItemState();
}

class _LessonListeningItemState extends State<LessonListeningItem> {
  late ConnectivityResult _connectivityStatus;
  bool isExpanded = false; // Control if the item is expanded
  bool isPlaying = false;
  Duration totalDuration = Duration.zero;
  Duration currentDuration = Duration.zero;
  late final StreamSubscription<MediaItem?> _mediaItemSubscription;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    _mediaItemSubscription = globalAudioHandler.mediaItem.listen((mediaItem) {
      if (mediaItem != null && mediaItem.extras != null) {
        final playingIndex = mediaItem.extras!['lessonIndex'] as int?;
        // If this widget's index is the current playing one, expand it.
        if (playingIndex != null && playingIndex == widget.lessonIndex) {
          if (!isExpanded) {
            setState(() {
              isExpanded = true;
            });
          }
        } else {
          // Optionally, collapse if it is not the playing item.
          if (isExpanded) {
            setState(() {
              isExpanded = false;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _mediaItemSubscription.cancel();
    super.dispose();
  }

  Future<void> _checkInternetConnection() async {
    final List<ConnectivityResult> connectivityResults =
        await Connectivity().checkConnectivity();
    if (mounted) {
      setState(() {
        _connectivityStatus =
            connectivityResults.contains(ConnectivityResult.none)
                ? ConnectivityResult.none
                : connectivityResults.first;
      });
    }
  }

  void _handleAudioAction(Function() action) {
    if (_connectivityStatus == ConnectivityResult.none) {
      showOfflineMessage();
    } else {
      action();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: globalAudioHandler.mediaItem,
      builder: (context, snapshot) {
        final currentMedia = snapshot.data;
        // Check if current media has the expected extras and matching index
        if (currentMedia?.extras != null) {
          final playingIndex = currentMedia!.extras!['Index'] as int?;
          // If the current media's index matches this widget's index, expand the item
          if (playingIndex != null &&
              playingIndex == widget.lessonIndex &&
              !isExpanded) {
            // Scheduling a state update outside of build method context
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                isExpanded = true;
              });
            });
          }
        }
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: buildLessonItem(),
            ),
          ],
        );
      },
    );
  }

  Widget buildLessonItem() {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Colors.black, spreadRadius: .1)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildNameRow(),
          if (isExpanded) buildExpandedContent(),
        ],
      ),
    );
  }

  // Helper: Play previous lesson.
  void playPreviousLesson(AudioPlayerHandler audioHandler) {
    int prevIndex = widget.lessonIndex - 1;
    if (prevIndex < 0) {
      showMessage("لا يوجد درس سابق");
      return;
    }
    String prevAudioUrl = widget.getAudioUrl(prevIndex);
    audioHandler.togglePlayPause(
      isPlaying: false,
      audioUrl: prevAudioUrl,
      albumName: widget.description,
      title: widget.playlist[prevIndex].title,
      index: prevIndex,
      setIsPlaying: (_) {},
      playlistIndex: prevIndex,
    );
  }

  // Helper: Play next lesson.
  void playNextLesson(AudioPlayerHandler audioHandler) {
    int nextIndex = widget.lessonIndex + 1;
    if (nextIndex >= widget.totalLessons) {
      showMessage("لا يوجد درس تالي");
      return;
    }
    String nextAudioUrl = widget.getAudioUrl(nextIndex);
    audioHandler.togglePlayPause(
      isPlaying: false,
      audioUrl: nextAudioUrl,
      albumName: widget.description,
      title: widget.playlist[nextIndex].title,
      index: nextIndex,
      setIsPlaying: (_) {},
      playlistIndex: nextIndex,
    );
  }

  Widget buildNameRow() {
    final favDarsProvider = Provider.of<FavDarsProvider>(context);

    // Check if the current page is bookmarked
    final isFavorite = favDarsProvider.favsDars
        .any((favsDars) => favsDars.url == widget.audioUrl);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // Center items vertically
      children: [
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () async {
            // Check if the item is already a favorite
            final isFavorite = favDarsProvider.favsDars
                .any((favDars) => favDars.url == widget.audioUrl);

            if (isFavorite) {
              // Remove from favorites
              final index = favDarsProvider.favsDars.indexWhere(
                (favDars) => favDars.url == widget.audioUrl,
              );

              // Ensure async call is awaited
              await favDarsProvider.removeFavDars(index);
            } else {
              // Add to favorites
              final newFavDars = FavDarsModel(
                name: widget.title,
                url: widget.audioUrl,
              );

              // Ensure async call is awaited
              await favDarsProvider.addFavDars(newFavDars);
            }

            // Update the UI after the favorite status changes
            if (mounted) {
              setState(() {});
            }
          },
          child: isFavorite
              ? const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 30,
                )
              : SvgPicture.asset(
                  height: 30,
                  Assets.imagesHeart,
                  placeholderBuilder: (context) => const Icon(Icons.error),
                ),
        ),
        const SizedBox(width: 10),
        // Expanded text to allow full view of long titles
        Expanded(
          child: Text(
            widget.title,
            style: AppStyles.alwaysBlack18(context),
            textAlign: TextAlign.right, // Align the text to the right
          ),
        ),
        const SizedBox(width: 10),
        buildActionButtons(), // Action buttons will remain visible
      ],
    );
  }

  Widget buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => shareAudio(widget.audioUrl),
          child: SvgPicture.asset(
            height: 30,
            Assets.imagesShare,
            placeholderBuilder: (context) => const Icon(Icons.error),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => _handleAudioAction(() {
            showMessage("جاري التحميل...");

            downloadAudio(widget.audioUrl, widget.title, context);
          }),
          child: SvgPicture.asset(
            height: 30,
            Assets.imagesDocumentDownload,
            placeholderBuilder: (context) => const Icon(Icons.error),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget buildExpandedContent() {
    return Column(
      children: [
        buildDurationRow(globalAudioHandler),
        buildSlider(globalAudioHandler),
        buildControlButtons(),
      ],
    );
  }

  Widget buildDurationRow(AudioPlayerHandler audioHandler) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, mediaSnapshot) {
        final currentMedia = mediaSnapshot.data;
        if (currentMedia != null && currentMedia.id == widget.audioUrl) {
          return StreamBuilder<Duration>(
            stream: audioHandler.positionStream,
            builder: (context, posSnapshot) {
              final position = posSnapshot.data ?? Duration.zero;
              return StreamBuilder<Duration?>(
                stream: audioHandler.durationStream,
                builder: (context, durSnapshot) {
                  final duration = durSnapshot.data ?? Duration.zero;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: AppStyles.alwaysBlack18(context)),
                        Text(
                            '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: AppStyles.alwaysBlack18(context)),
                      ],
                    ),
                  );
                },
              );
            },
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('0:00', style: AppStyles.alwaysBlack18(context)),
                Text('0:00', style: AppStyles.alwaysBlack18(context)),
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildSlider(AudioPlayerHandler audioHandler) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        final currentMedia = snapshot.data;
        if (currentMedia != null && currentMedia.id == widget.audioUrl) {
          return StreamBuilder<Duration>(
            stream: audioHandler.positionStream,
            builder: (context, posSnapshot) {
              final position = posSnapshot.data ?? Duration.zero;
              return StreamBuilder<Duration?>(
                stream: audioHandler.durationStream,
                builder: (context, durSnapshot) {
                  final duration = durSnapshot.data ?? Duration.zero;
                  return Slider(
                    activeColor: AppColors.kSecondaryColor,
                    inactiveColor: AppColors.kPrimaryColor,
                    value: position.inSeconds.toDouble(),
                    max: duration.inSeconds > 0
                        ? duration.inSeconds.toDouble()
                        : 1,
                    onChanged: (value) {
                      audioHandler.seek(Duration(seconds: value.toInt()));
                    },
                  );
                },
              );
            },
          );
        } else {
          return Slider(
            activeColor: AppColors.kSecondaryColor,
            inactiveColor: AppColors.kPrimaryColor,
            value: 0,
            max: 1,
            onChanged: null,
          );
        }
      },
    );
  }

  Widget buildControlButtons() {
    final audioHandler = globalAudioHandler;
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, mediaSnapshot) {
        final currentMedia = mediaSnapshot.data;
        final controlsEnabled =
            currentMedia != null && currentMedia.id == widget.audioUrl;
        return StreamBuilder<PlaybackState>(
          stream: audioHandler.playbackState,
          builder: (context, playbackSnapshot) {
            final playing =
                controlsEnabled && (playbackSnapshot.data?.playing ?? false);
            final isLoading = playbackSnapshot.data?.processingState ==
                AudioProcessingState.loading;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Previous lesson button.
                IconButton(
                  onPressed: controlsEnabled
                      ? () => playPreviousLesson(audioHandler)
                      : null,
                  icon: Icon(
                    Icons.skip_next,
                    size: 30,
                    color: controlsEnabled
                        ? AppColors.kSecondaryColor
                        : Colors.grey,
                  ),
                ),
                // Speed decrease button.
                IconButton(
                  onPressed: controlsEnabled
                      ? () => audioHandler.decreaseSpeed()
                      : null,
                  icon: Icon(
                    Icons.fast_forward,
                    size: 30,
                    color: controlsEnabled
                        ? AppColors.kSecondaryColor
                        : Colors.grey,
                  ),
                ),
                // Play/Pause button with loading indicator.
                IconButton(
                  onPressed: () {
                    _handleAudioAction(() {
                      audioHandler.togglePlayPause(
                        albumName: widget.title,
                        title: widget.title,
                        isPlaying: playing,
                        audioUrl: widget.audioUrl,
                        index: widget.lessonIndex,
                        setIsPlaying: (_) {},
                        playlistIndex: widget.lessonIndex,
                      );
                    });
                  },
                  icon: isLoading
                      ? SizedBox(
                          height: 45,
                          width: 45,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.kSecondaryColor),
                          ),
                        )
                      : Icon(
                          playing ? Icons.pause_circle : Icons.play_circle,
                          color: AppColors.kSecondaryColor,
                          size: 45,
                        ),
                ),
                // Speed increase button.
                IconButton(
                  onPressed: controlsEnabled
                      ? () => audioHandler.increaseSpeed()
                      : null,
                  icon: Icon(
                    Icons.fast_rewind,
                    size: 30,
                    color: controlsEnabled
                        ? AppColors.kSecondaryColor
                        : Colors.grey,
                  ),
                ),
                // Next lesson button.
                IconButton(
                  onPressed: controlsEnabled
                      ? () => playNextLesson(audioHandler)
                      : null,
                  icon: Icon(
                    Icons.skip_previous,
                    size: 30,
                    color: controlsEnabled
                        ? AppColors.kSecondaryColor
                        : Colors.grey,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
