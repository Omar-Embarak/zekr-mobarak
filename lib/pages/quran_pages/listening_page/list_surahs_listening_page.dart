import 'dart:developer';
import 'package:azkar_app/cubit/add_fav_surahcubit/add_fav_surah_item_cubit.dart';
import 'package:azkar_app/model/quran_models/reciters_model.dart';
import 'package:flutter/material.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:quran/quran.dart' as quran;
import '../../../constants.dart';
import '../../../main.dart';
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
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      // Build the playlist synchronously
      List<String> playlist = [];
      if (widget.reciter.zeroPaddingSurahNumber) {
        for (int i = 1; i <= 114; i++) {
          playlist
              .add('${widget.reciter.url}${i.toString().padLeft(3, '0')}.mp3');
        }
      } else {
        for (int i = 1; i <= 114; i++) {
          playlist.add('${widget.reciter.url}$i.mp3');
        }
      }

      // Set up the audio source asynchronously.
      await globalAudioHandler.setAudioSourceWithPlaylist(
        playlist: playlist,
        index: 0, // Start from the first surah.
        reciterName: widget.reciter.name,
        surahName:
            quran.getSurahNameArabic(1), // Assuming first surah is Al-Fatiha.
        reciterUrl: widget.reciter.url,
        zeroPadding: widget.reciter.zeroPaddingSurahNumber,
        artUri: null,
      );
      setState(() {
        _isLoaded = true;
      });
    } catch (e) {
      // Handle errors gracefully
      log("Error during audio initialization: $e");
      // Optionally, update state to show an error message or a retry button.
    }
  }

  void updateTappedSurahName(int surahIndex) {
    setState(() {
      tappedSurahName =
          'تشغيل سورة ${quran.getSurahNameArabic(surahIndex + 1)} الآن';
    });
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
          ? Center(child: CircularProgressIndicator())
          : BlocConsumer<AddFavSurahItemCubit, AddFavSurahItemState>(
              listener: (context, state) {},
              builder: (context, state) {
                return ModalProgressHUD(
                  inAsyncCall: state is AddFavSurahItemLoading,
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
                                    surahIndex: surahIndex,
                                    audioUrl: audioUrl,
                                    onSurahTap: updateTappedSurahName,
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
