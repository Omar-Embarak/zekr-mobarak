import 'package:audioplayers/audioplayers.dart';
import 'package:azkar_app/model/fav_dars_model.dart';
import 'package:azkar_app/pages/droos_pages/fav_dars_provider.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../methods.dart';
import '../../utils/app_images.dart';
import '../../widgets/icon_constrain_widget.dart';

class DarsListeningItem extends StatefulWidget {
  final String audioUrl;
  final String title;

  const DarsListeningItem({
    super.key,
    required this.audioUrl,
    required this.title,
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
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();

    initializeAudioPlayer(
        _audioPlayer, setTotalDuration, setCurrentDuration, setIsPlaying);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _checkInternetConnection() async {
    final List<ConnectivityResult> connectivityResults =
        await Connectivity().checkConnectivity();
    setState(() {
      _connectivityStatus =
          connectivityResults.contains(ConnectivityResult.none)
              ? ConnectivityResult.none
              : connectivityResults.first;
    });
  }

  void setTotalDuration(Duration duration) {
    setState(() {
      totalDuration = duration;
    });
  }

  void setCurrentDuration(Duration duration) {
    setState(() {
      currentDuration = duration;
    });
  }

  void setIsPlaying(bool playing) {
    setState(() {
      isPlaying = playing;
    });
  }

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void _showOfflineMessage() {
    showMessage('لا يتوفر اتصال بالانترنت.');
  }

  void _handleAudioAction(Function() action) {
    if (_connectivityStatus == ConnectivityResult.none) {
      _showOfflineMessage();
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
      crossAxisAlignment: CrossAxisAlignment.start, // Align for long text
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
            setState(() {});
          },
          child: isFavorite
              ? const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 30,
                )
              : const IconConstrain(
                  height: 30,
                  imagePath: Assets.imagesHeart,
                ),
        ),
        const SizedBox(width: 10),
        // Expanded text to allow full view of long titles
        Expanded(
          child: Text(
            widget.title,
            style: AppStyles.styleRajdhaniMedium18(context),
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
          child: const IconConstrain(height: 30, imagePath: Assets.imagesShare),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => _handleAudioAction(() {
            downloadAudio(widget.audioUrl, widget.title, context);
          }),
          child: const IconConstrain(
              height: 30, imagePath: Assets.imagesDocumentDownload),
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
          buildSlider(),
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
            style: AppStyles.styleRajdhaniMedium18(context),
          ),
          Text(
            '${totalDuration.inMinutes}:${(totalDuration.inSeconds % 60).toString().padLeft(2, '0')}',
            style: AppStyles.styleRajdhaniMedium18(context),
          ),
        ],
      ),
    );
  }

  Widget buildSlider() {
    return Slider(
      activeColor: AppColors.kSecondaryColor,
      inactiveColor: AppColors.kPrimaryColor,
      value: currentDuration.inSeconds.toDouble(),
      max: totalDuration.inSeconds.toDouble(),
      onChanged: (value) {
        setState(() {
          currentDuration = Duration(seconds: value.toInt());
        });
        _audioPlayer.seek(currentDuration);
      },
    );
  }

  Widget buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () => forward(_audioPlayer),
          child:
              const IconConstrain(height: 24, imagePath: Assets.imagesForward),
        ),
        IconButton(
          onPressed: () => _handleAudioAction(() {
            togglePlayPause(
                _audioPlayer, isPlaying, widget.audioUrl, setIsPlaying, null);
          }),
          icon: Icon(
            isPlaying ? Icons.pause_circle : Icons.play_circle,
            color: AppColors.kSecondaryColor,
            size: 45,
          ),
        ),
        GestureDetector(
          onTap: () => backward(_audioPlayer),
          child:
              const IconConstrain(height: 24, imagePath: Assets.imagesBackward),
        ),
      ],
    );
  }
}
