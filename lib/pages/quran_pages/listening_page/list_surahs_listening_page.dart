import 'package:azkar_app/cubit/fav_surah_cubit/fav_surah_item_cubit.dart';
import 'package:azkar_app/model/quran_models/reciters_model.dart';
import 'package:flutter/material.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:quran/quran.dart' as quran;
import '../../../constants.dart';
import '../../../main.dart';
import '../../../model/audio_model.dart';
import '../../../widgets/surah_listening_item_widget.dart';

class ListSurahsListeningPage extends StatefulWidget {
  final RecitersModel reciter;

  const ListSurahsListeningPage({
    super.key,
    required this.reciter,
  });

  @override
  State<ListSurahsListeningPage> createState() =>
      _ListSurahsListeningPageState();
}

class _ListSurahsListeningPageState extends State<ListSurahsListeningPage> {
  String? tappedSurahName;
  final TextEditingController _searchController = TextEditingController();
  List<int> filteredSurahs = List.generate(114, (index) => index + 1);
  bool _isSearching = false;
  bool _isLoaded = false;
  @override
  void initState() {
    super.initState();
    _initPlayList();
  }

  Future<void> _initPlayList() async {
    // Build the playlist synchronously
    List<AudioModel> playlist = [];
    if (widget.reciter.zeroPaddingSurahNumber) {
      for (int i = 1; i <= 114; i++) {
        playlist.add(AudioModel(
          audioURL: '${widget.reciter.url}${i.toString().padLeft(3, '0')}.mp3',
          title: quran.getSurahNameArabic(i),
          album: widget.reciter.name,
        ));
      }
    } else {
      for (int i = 1; i <= 114; i++) {
        playlist.add(AudioModel(
          audioURL: '${widget.reciter.url}$i.mp3',
          title: quran.getSurahNameArabic(i),
          album: widget.reciter.name,
        ));
      }
    }

    // Set up the audio source asynchronously.
    await globalAudioHandler.setAudioSourceWithPlaylist(
      playlist: playlist,
      index: 0, // Start from the first surah.
      album: widget.reciter.name,
      title: quran.getSurahNameArabic(1), // Assuming first surah is Al-Fatiha.

      artUri: null,
    );
    setState(() {
      _isLoaded = true;
    });
  }

  void updateTappedSurahName(int surahIndex) {
    if (mounted) {
      setState(() {
        tappedSurahName =
            'تشغيل سورة ${quran.getSurahNameArabic(surahIndex + 1)} الآن';
      });
    }
  }

  void _filterSurahs(String query) {
    setState(() {
      filteredSurahs = List.generate(114, (index) => index + 1)
          .where((index) => quran.getSurahNameArabic(index).contains(query))
          .toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filterSurahs(''); // Reset list when search closes.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kSecondaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: AppStyles.styleCairoMedium15white(context).color),
        centerTitle: true,
        title: _isSearching
            ? TextField(
                style: AppStyles.styleCairoMedium15white(context),
                controller: _searchController,
                onChanged: _filterSurahs,
                decoration: const InputDecoration(
                  hintText: 'إبحث عن سورة ...',
                  border: InputBorder.none,
                ),
                autofocus: true,
              )
            : Text('استماع القران الكريم',
                style: AppStyles.styleCairoMedium15white(context)),
        backgroundColor: AppColors.kPrimaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: _toggleSearch,
              child: Icon(_isSearching ? Icons.close : Icons.search),
            ),
          )
        ],
      ),
      body: !_isLoaded
          ? const Center(child: CircularProgressIndicator())
          : BlocConsumer<FavSurahItemCubit, FavSurahItemState>(
              listener: (context, state) {},
              builder: (context, state) {
                return ModalProgressHUD(
                  inAsyncCall: state is FavSurahItemLoading,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              widget.reciter.name,
                              style:
                                  AppStyles.styleDiodrumArabicbold20(context),
                            ),
                            if (tappedSurahName != null)
                              Text(
                                tappedSurahName!,
                                style:
                                    AppStyles.styleCairoMedium15white(context),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: filteredSurahs.isNotEmpty
                            ? ListView.builder(
                                padding: const EdgeInsets.only(bottom: 20),
                                itemCount: filteredSurahs.length,
                                itemBuilder: (context, index) {
                                  final surahIndex = filteredSurahs[index] - 1;
                                  final audioUrl = widget
                                          .reciter.zeroPaddingSurahNumber
                                      ? '${widget.reciter.url}${(surahIndex + 1).toString().padLeft(3, '0')}.mp3'
                                      : '${widget.reciter.url}${surahIndex + 1}.mp3';

                                  return SurahListeningItem(
                                    index: surahIndex,
                                    audioUrl: audioUrl,
                                    onAudioTap: updateTappedSurahName,
                                    reciter: widget.reciter,
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  'اسم السورة غير صحيح.',
                                  style: AppStyles.styleDiodrumArabicbold20(
                                      context),
                                ),
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
