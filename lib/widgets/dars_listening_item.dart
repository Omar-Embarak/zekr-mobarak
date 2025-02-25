// import 'package:audioplayers/audioplayers.dart';
import 'package:audio_service/audio_service.dart';
import 'package:azkar_app/model/fav_dars_model.dart';
import 'package:azkar_app/pages/droos_pages/fav_dars_provider.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../methods.dart';
import '../../utils/app_images.dart';
import '../../widgets/icon_constrain_widget.dart';
import '../main.dart';
import '../pages/sevices/audio_handler.dart';

class DarsListeningItem extends StatefulWidget {
  final String audioUrl;
  final String title;
  final String description;

  const DarsListeningItem({
    super.key,
    required this.audioUrl,
    required this.title,
    required this.description,
  });

  @override
  State<DarsListeningItem> createState() => _SurahListeningItemState();
}

class _SurahListeningItemState extends State<DarsListeningItem> {
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
    return Column(
      children: [
        GestureDetector(
          onTap: toggleExpanded, // Toggle expanded/collapsed on tap
          child: buildSurahItem(),
        ),
      ],
    );
  }

  Widget buildSurahItem() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: .1,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildSurahRow(),
          if (isExpanded)
            buildExpandedContent(), // Show expanded content if needed
        ],
      ),
    );
  }

  Widget buildSurahRow() {
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          buildDurationRow(),
          buildSlider(globalAudioHandler),
          buildControlButtons(),
        ],
      ),
    );
  }

  Widget buildDurationRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${currentDuration.inMinutes}:${(currentDuration.inSeconds % 60).toString().padLeft(2, '0')}',
            style: AppStyles.alwaysBlack18(context),
          ),
          Text(
            '${totalDuration.inMinutes}:${(totalDuration.inSeconds % 60).toString().padLeft(2, '0')}',
            style: AppStyles.alwaysBlack18(context),
          ),
        ],
      ),
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
    final audioHandler = AudioPlayerHandler();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () => forward(globalAudioHandler),
          child:
              const IconConstrain(height: 24, imagePath: Assets.imagesForward),
        ),
        // At the top of your widget build method or in an appropriate place:

        IconButton(
          onPressed: () {
            // If you don't have _handleAudioAction defined, just call directly:
            audioHandler.togglePlayPause(
                surahName: widget.title,
                reciterName: widget.description,
                isPlaying: isPlaying,
                audioUrl: widget.audioUrl,
                setIsPlaying: setIsPlaying,
                onSurahTap: null);
          },
          icon: Icon(
            isPlaying ? Icons.pause_circle : Icons.play_circle,
            color: AppColors.kSecondaryColor,
            size: 45,
          ),
        ),
        GestureDetector(
          onTap: () => backward(globalAudioHandler),
          child:
              const IconConstrain(height: 24, imagePath: Assets.imagesBackward),
        ),
      ],
    );
  }
}
