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
  final int index;
  final int totalLessons;
  final String audioUrl;
  final String title;
  final String? description;
  final String Function(int index) getAudioUrl;
  final List<AudioModel> playlist;
  const LessonListeningItem({
    super.key,
    required this.index,
    required this.totalLessons,
    required this.audioUrl,
    required this.title,
    this.description,
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
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    currentIndex = widget.index;

    // Subscribe to the media item stream
    _mediaItemSubscription = globalAudioHandler.mediaItem.listen((mediaItem) {
      if (mediaItem != null && mediaItem.extras != null) {
        final playingIndex = mediaItem.extras!['index'] as int?;
        // If this widget's index is the current playing one, expand it.
        if (playingIndex != null && playingIndex == widget.index) {
          if (!isExpanded) {
            setState(() {
              isExpanded = true;
            });
          }
        } else if (isExpanded) {
          // Optionally collapse if item is not playing
          setState(() {
            isExpanded = false;
          });
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

        // Check if current media matches this item's index
        if (currentMedia?.extras != null) {
          final playingIndex = currentMedia!.extras!['index'] as int?;
          if (playingIndex != null && playingIndex == widget.index) {
            if (!isExpanded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  isExpanded = true;
                });
              });
            }
          }
        }

        return GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded; // Toggle the expansion state
            });
          },
          child: buildLessonItem(),
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
    currentIndex -= 1;
    showMessage("جاري تشغيل الدرس السابق");

    if (currentIndex < 0) {
      showMessage("لا يوجد درس سابق");
      return;
    }
    audioHandler.togglePlayPause(
      isPlaying: false,
      audioUrl: widget.getAudioUrl(currentIndex),
      albumName: widget.description ?? '',
      title: widget.playlist[currentIndex].title,
      index: currentIndex,
      setIsPlaying: (_) {},
      playlistIndex: currentIndex,
    );
  }

  // Helper: Play next lesson.
  void playNextLesson(AudioPlayerHandler audioHandler) {
    currentIndex += 1;
    showMessage("جاري تشغيل الدرس التالي");

    if (currentIndex >= widget.totalLessons) {
      showMessage("لا يوجد درس تالي");
      return;
    }
    audioHandler.togglePlayPause(
      isPlaying: false,
      audioUrl: widget.getAudioUrl(currentIndex),
      albumName: widget.description ?? '',
      title: widget.playlist[currentIndex].title,
      index: currentIndex,
      setIsPlaying: (_) {},
      playlistIndex: currentIndex,
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
        buildDurationRow(),
        buildSlider(),
        buildControlButtons(),
      ],
    );
  }

  Widget buildDurationRow() {
    return StreamBuilder<MediaItem?>(
      stream: globalAudioHandler.mediaItem,
      builder: (context, mediaSnapshot) {
        if (globalAudioHandler.mediaItem.value?.extras?['index'] ==
            widget.index) {
          return StreamBuilder<Duration>(
            stream: globalAudioHandler.positionStream,
            builder: (context, posSnapshot) {
              final position = posSnapshot.data ?? Duration.zero;
              return StreamBuilder<Duration?>(
                stream: globalAudioHandler.durationStream,
                builder: (context, durSnapshot) {
                  final duration = durSnapshot.data ?? Duration.zero;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}',
                          style: AppStyles.alwaysBlack18(context),
                        ),
                        Text(
                          '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                          style: AppStyles.alwaysBlack18(context),
                        ),
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

  Widget buildSlider() {
    return StreamBuilder<MediaItem?>(
      stream: globalAudioHandler.mediaItem,
      builder: (context, snapshot) {
        if (globalAudioHandler.mediaItem.value?.extras?['index'] ==
            widget.index) {
          return StreamBuilder<Duration>(
            stream: globalAudioHandler.positionStream,
            builder: (context, posSnapshot) {
              final position = posSnapshot.data ?? Duration.zero;
              return StreamBuilder<Duration?>(
                stream: globalAudioHandler.durationStream,
                builder: (context, durSnapshot) {
                  final duration = durSnapshot.data ?? Duration.zero;

                  // Make sure to prevent any assertion errors
                  double max = duration.inSeconds > 0
                      ? duration.inSeconds.toDouble()
                      : 1;
                  double currentVal = position.inSeconds.toDouble();

                  // Clamp the current value between the min and max bounds
                  currentVal = currentVal > max
                      ? max
                      : currentVal < 0
                          ? 0
                          : currentVal;

                  return Slider(
                    activeColor: AppColors.kSecondaryColor,
                    inactiveColor: AppColors.kPrimaryColor,
                    value: currentVal,
                    max: max,
                    min: 0, // Set minimum value to 0
                    onChanged: (value) {
                      globalAudioHandler.seek(Duration(seconds: value.toInt()));
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
            min: 0,
            max: 1,
            onChanged: null,
          );
        }
      },
    );
  }

  Widget buildControlButtons() {
    return StreamBuilder<PlaybackState>(
      stream: globalAudioHandler.playbackState,
      builder: (context, snapshot) {
        final playbackState = snapshot.data;
        final isCurrentItem =
            globalAudioHandler.mediaItem.value?.extras?['index'] ==
                widget.index;

        final bool playing = playbackState?.playing ?? false;
        final bool isLoading = playbackState?.processingState ==
                AudioProcessingState.loading ||
            playbackState?.processingState == AudioProcessingState.buffering;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Previous button
            IconButton(
              onPressed: isCurrentItem && playing
                  ? () => playPreviousLesson(globalAudioHandler)
                  : null,
              icon: Icon(
                Icons.skip_next,
                size: 30,
                color: isCurrentItem && playing ? Colors.black : Colors.grey,
              ),
            ),

            // Speed decrease
            IconButton(
              onPressed: isCurrentItem && playing
                  ? () => globalAudioHandler.decreaseSpeed()
                  : null,
              icon: Icon(
                Icons.fast_forward,
                size: 30,
                color: isCurrentItem && playing ? Colors.black : Colors.grey,
              ),
            ),

            // Play/Pause button
            IconButton(
              onPressed: () {
                _handleAudioAction(() {
                  globalAudioHandler.togglePlayPause(
                    isPlaying: isCurrentItem && playing,
                    audioUrl: widget.audioUrl,
                    albumName: widget.description ?? '',
                    title: widget.title,
                    index: widget.index,
                    playlistIndex: widget.index,
                    setIsPlaying: (playing) {
                      if (mounted) {
                        setState(() {
                          isPlaying = playing;
                        });
                      }
                    },
                  );
                });
              },
              icon: isLoading ||
                      (isCurrentItem &&
                          playbackState?.processingState !=
                              AudioProcessingState.ready)
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
                      isCurrentItem && playing
                          ? Icons.pause_circle
                          : Icons.play_circle,
                      color: Colors.black,
                      size: 45,
                    ),
            ),

            // Speed increase
            IconButton(
              onPressed: isCurrentItem && playing
                  ? () => globalAudioHandler.increaseSpeed()
                  : null,
              icon: Icon(
                Icons.fast_rewind,
                size: 30,
                color: isCurrentItem && playing ? Colors.black : Colors.grey,
              ),
            ),

            // Next button
            IconButton(
              onPressed: isCurrentItem && playing
                  ? () => playNextLesson(globalAudioHandler)
                  : null,
              icon: Icon(
                Icons.skip_previous,
                size: 30,
                color: isCurrentItem && playing ? Colors.black : Colors.grey,
              ),
            ),
          ],
        );
      },
    );
  }
}
