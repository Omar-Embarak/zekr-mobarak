import 'dart:async';
import 'package:azkar_app/model/quran_models/reciters_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran/quran.dart' as quran;
import '../cubit/add_fav_surahcubit/add_fav_surah_item_cubit.dart';
import '../database_helper.dart';
import '../model/quran_models/fav_model.dart';
import '../methods.dart';
import '../constants.dart';
import '../utils/app_images.dart';
import '../utils/app_style.dart';

class SurahListeningItem extends StatefulWidget {
  final int surahIndex;
  final String audioUrl;
  final void Function(int surahIndex)? onSurahTap;
  final RecitersModel reciter;

  const SurahListeningItem({
    super.key,
    required this.surahIndex,
    required this.audioUrl,
    this.onSurahTap,
    required this.reciter,
  });

  @override
  State<SurahListeningItem> createState() => _SurahListeningItemState();
}

class _SurahListeningItemState extends State<SurahListeningItem> {
  bool isExpanded = false;
  bool isPlaying = false;
  bool isFavorite = false;
  Duration totalDuration = Duration.zero;
  Duration currentDuration = Duration.zero;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late ConnectivityResult _connectivityStatus;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  @override
  void initState() {
    super.initState();
    _initializeFavoriteState();
    _initializeAudioPlayer();
    _checkInternetConnection();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeAudioPlayer() async {
    _playerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          totalDuration = duration;
        });
      }
    });
    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          currentDuration = position;
        });
      }
    });
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

  Future<void> _initializeFavoriteState() async {
    // Check if this surah is marked as favorite
    final favoriteState = await _databaseHelper.isFavoriteExists(
        widget.surahIndex, widget.reciter.name);
    if (mounted) {
      setState(() {
        isFavorite = favoriteState;
      });
    }
  }

  void toggleFavorite() {
    if (mounted) {
      setState(() {
        isFavorite = !isFavorite;
        if (isFavorite) {
          var favSurahModel = FavModel(
            url: widget.audioUrl,
            reciter: widget.reciter,
            surahIndex: widget.surahIndex,
          );
          BlocProvider.of<AddFavSurahItemCubit>(context)
              .addFavSurahItem(favSurahModel);
        } else {
          BlocProvider.of<AddFavSurahItemCubit>(context)
              .deleteFavSurah(widget.surahIndex, widget.reciter.name);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (mounted) {
              setState(() {
                isExpanded = !isExpanded;
              });
            }
          },
          child: buildSurahItem(),
        ),
      ],
    );
  }

  Widget buildSurahItem() {
    return Container(
      height: isExpanded ? null : 53,
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
          if (isExpanded) buildExpandedContent(),
        ],
      ),
    );
  }

  Widget buildSurahRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 10),
        GestureDetector(
          onTap: toggleFavorite,
          child: isFavorite
              ? const Icon(Icons.favorite, color: Colors.red, size: 30)
              : SvgPicture.asset(
                  height: 30,
                  Assets.imagesHeart,
                  placeholderBuilder: (context) => const Icon(Icons.error),
                ),
        ),
        const SizedBox(width: 10),
        Text(
          'سورة ${quran.getSurahNameArabic(widget.surahIndex + 1)}',
          style: AppStyles.styleRajdhaniMedium18(context)
              .copyWith(color: Colors.black),
        ),
        const Spacer(),
        buildActionButtons(),
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
            downloadAudio(widget.audioUrl,
                quran.getSurahNameArabic(widget.surahIndex + 1), context);
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

  Widget buildSlider() {
    return Slider(
      activeColor: AppColors.kSecondaryColor,
      inactiveColor: AppColors.kPrimaryColor,
      value: currentDuration.inSeconds.toDouble(),
      max: totalDuration.inSeconds > 0 ? totalDuration.inSeconds.toDouble() : 1,
      onChanged: totalDuration.inSeconds > 0
          ? (value) {
              if (mounted) {
                setState(() {
                  currentDuration = Duration(seconds: value.toInt());
                });
              }
              _audioPlayer.seek(currentDuration);
            }
          : null,
    );
  }

  Widget buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () => backward(_audioPlayer),
          child: SvgPicture.asset(
            height: 24,
            Assets.imagesForward,
            placeholderBuilder: (context) => const Icon(Icons.error),
          ),
        ),
        IconButton(
          onPressed: () => _handleAudioAction(() {
            togglePlayPause(
              _audioPlayer,
              isPlaying,
              widget.audioUrl,
              setIsPlaying,
              widget.onSurahTap != null
                  ? () => widget.onSurahTap!(widget.surahIndex)
                  : null,
            );
          }),
          icon: Icon(
            isPlaying ? Icons.pause_circle : Icons.play_circle,
            color: AppColors.kSecondaryColor,
            size: 45,
          ),
        ),
        GestureDetector(
          onTap: () => forward(_audioPlayer),
          child: SvgPicture.asset(
            height: 24,
            Assets.imagesBackward,
            placeholderBuilder: (context) => const Icon(Icons.error),
          ),
        ),
      ],
    );
  }

  void setIsPlaying(bool value) {
    if (mounted) {
      setState(() {
        isPlaying = value;
      });
    }
  }
}
