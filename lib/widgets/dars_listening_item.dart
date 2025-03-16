// import 'package:audioplayers/audioplayers.dart';
import 'package:audio_service/audio_service.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants.dart';
import '../../methods.dart';
import '../../utils/app_images.dart';
import '../main.dart';
import '../pages/sevices/audio_handler.dart';

class DarsListeningItem extends StatefulWidget {
  final int darsIndex;
  final int totalLessons;
  final String audioUrl;
  final String title;
  final String description;
  final String Function(int index) getAudioUrl;

  const DarsListeningItem({
    super.key,
    required this.darsIndex,
    required this.totalLessons,
    required this.audioUrl,
    required this.title,
    required this.description,
    required this.getAudioUrl,
  });

  @override
  State<DarsListeningItem> createState() => _DarsListeningItemState();
}

class _DarsListeningItemState extends State<DarsListeningItem> {
  late ConnectivityResult _connectivityStatus;
  bool isExpanded = false; // Control if the item is expanded
  bool isPlaying = false;
  Duration totalDuration = Duration.zero;
  Duration currentDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  @override
  void dispose() {
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

  void setTotalDuration(Duration duration) {
    if (mounted) {
      setState(() {
        totalDuration = duration;
      });
    }
  }

  void setCurrentDuration(Duration duration) {
    if (mounted) {
      setState(() {
        currentDuration = duration;
      });
    }
  }

  void setIsPlaying(bool playing) {
    if (mounted) {
      setState(() {
        isPlaying = playing;
      });
    }
  }

  void toggleExpanded() {
    if (mounted) {
      setState(() {
        isExpanded = !isExpanded;
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
    // Auto-expand if this item is the currently playing one.
    return StreamBuilder<MediaItem?>(
      stream: globalAudioHandler.mediaItem,
      builder: (context, snapshot) {
        final currentMedia = snapshot.data;
        if (currentMedia != null && currentMedia.extras != null) {
          final playingIndex = currentMedia.extras!['surahIndex'] as int?;
          if (playingIndex != null &&
              playingIndex == widget.darsIndex &&
              !isExpanded) {
            Future.microtask(() {
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
              child: buildDarsItem(),
            ),
          ],
        );
      },
    );
  }

  // Helper: Play previous lesson.
  void playPreviousLesson(AudioPlayerHandler audioHandler) {
    int prevIndex = widget.darsIndex - 1;
    if (prevIndex < 0) {
      showMessage("لا يوجد درس سابق");
      return;
    }
    String prevAudioUrl = widget.getAudioUrl(prevIndex);
    // audioHandler.togglePlayPause(
    //   isPlaying: false,
    //   audioUrl: prevAudioUrl,
    //   reciterName: widget.title, // using lesson title as metadata
    //   surahName: widget.title,
    //   surahIndex: prevIndex,
    //   reciterUrl: 'YOUR_LESSON_BASE_URL/', // update this URL accordingly
    //   setIsPlaying: (_) {},
    //   onSurahTap: () {},
    // );
    setState(() {
      isExpanded = true;
    });
  }

  // Helper: Play next lesson.
  void playNextLesson(AudioPlayerHandler audioHandler) {
    int nextIndex = widget.darsIndex + 1;
    if (nextIndex >= widget.totalLessons) {
      showMessage("لا يوجد درس تالي");
      return;
    }
    String nextAudioUrl = widget.getAudioUrl(nextIndex);
    // audioHandler.togglePlayPause(
    //   isPlaying: false,
    //   audioUrl: nextAudioUrl,
    //   reciterName: widget.title,
    //   surahName: widget.title,
    //   surahIndex: nextIndex,
    //   reciterUrl: 'YOUR_LESSON_BASE_URL/',
    //   setIsPlaying: (_) {},
    //   onSurahTap: () {},
    // );
    setState(() {
      isExpanded = true;
    });
  }

  Widget buildDarsItem() {
    return Container(
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
          buildDarsRow(),
          if (isExpanded) buildExpandedContent(),
        ],
      ),
    );
  }

  Widget buildDarsRow() {
    // You can include favorite and share functionality similar to surahs.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 10),
        // For simplicity, use an icon without favorite functionality here.
        Icon(Icons.music_note, size: 30, color: AppColors.kSecondaryColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            widget.title,
            style: AppStyles.alwaysBlack18(context),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: 10),
        // Placeholder for additional action buttons (like share)
        IconButton(
          onPressed: () => shareAudio(widget.audioUrl),
          icon: SvgPicture.asset(
            Assets.imagesShare,
            height: 30,
            placeholderBuilder: (context) => const Icon(Icons.error),
          ),
        ),
        const SizedBox(width: 10),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          buildDurationRow(globalAudioHandler),
          buildSlider(globalAudioHandler),
          buildControlButtons(),
        ],
      ),
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

// In your lesson item widget (e.g., DarsListeningItem)

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
                    Icons.skip_previous,
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
                    Icons.fast_rewind,
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
                      // audioHandler.togglePlayPause(
                      //   reciterName: widget.title,
                      //   surahName: widget.title,
                      //   isPlaying: playing,
                      //   audioUrl: widget.audioUrl,
                      //   surahIndex: widget.darsIndex,
                      //   reciterUrl: 'YOUR_LESSON_BASE_URL/',
                      //   setIsPlaying: (_) {},
                      //   onSurahTap: () {},
                      // );
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
                    Icons.fast_forward,
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
                    Icons.skip_next,
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
