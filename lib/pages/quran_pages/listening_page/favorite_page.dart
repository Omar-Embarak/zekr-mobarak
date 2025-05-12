import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../database_helper.dart';
import '../../../main.dart';
import '../../../model/audio_model.dart';
import '../../../model/quran_models/fav_model.dart';
import '../../../utils/app_style.dart';
import '../../../widgets/surah_listening_item_widget.dart';
import 'package:quran/quran.dart' as quran;

import 'list_surahs_listening_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<FavModel> _favorites = [];
  late DatabaseHelper _databaseHelper;
  // final TextEditingController _searchController = TextEditingController();
  // List<FavModel> filteredFavs = [];
  // final bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _loadFavorites();
    _initPlayList();
  }

  Future<void> _initPlayList() async {
    // Build the playlist from favorites
    List<AudioModel> playlist = _favorites.map((fav) {
      return AudioModel(
        audioURL: fav.url,
        title: quran.getSurahNameArabic(fav.surahIndex + 1),
        album: fav.reciter.name,
      );
    }).toList();

    if (playlist.isNotEmpty) {
      // Set up the audio source asynchronously without auto-playing
      await globalAudioHandler.setAudioSourceWithPlaylist(
        playlist: playlist,
        index: 0, // Default to first item but won't play automatically
        album: _favorites[0].reciter.name,
        title: quran.getSurahNameArabic(_favorites[0].surahIndex + 1),
        artUri: null,
      );
    }
  }

  @override
  void dispose() {
    // _searchController.dispose();
    super.dispose();
  }
void _loadFavorites() async {
  try {
    List<FavModel> favorites = await _databaseHelper.getFavorites();
    if (mounted) {
      setState(() {
        _favorites = favorites;
        // filteredFavs = favorites;
      });
      _initPlayList(); // Re-init playlist when favorites change
    }
  } catch (e) {
    debugPrint('Error loading favorites: $e');
  }
}
// void _removeFavorite(FavModel favModel) async {
//   await _databaseHelper.deleteFavorite(
//     favModel.surahIndex, 
//     favModel.reciter.name
//   );
//   _loadFavorites(); // Refresh list
// }

  // void _filterFavs(String query) {
  //   setState(() {
  //     if (query.trim().isEmpty) {
  //       // filteredFavs = _favorites;
  //       return;
  //     }
  //     final normalizedQuery = query.trim();
  //     if (normalizedQuery == 'سورة' ||
  //         normalizedQuery == 'س' ||
  //         normalizedQuery == 'سو' ||
  //         normalizedQuery == 'سور') {
  //       // filteredFavs = _favorites;
  //       return;
  //     }

  //     filteredFavs = _favorites.where((fav) {
  //       final surahName = quran.getSurahNameArabic(fav.surahIndex + 1).trim();
  //       return surahName.contains(normalizedQuery);
  //     }).toList();
  //   });
  // }

  // void _toggleSearch() {
  //   setState(() {
  //     _isSearching = !_isSearching;
  //     if (!_isSearching) {
  //       _searchController.clear();
  //       _filterFavs('');
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
          iconTheme: IconThemeData(
              color: AppStyles.styleCairoMedium15white(context).color),
          backgroundColor: AppColors.kSecondaryColor,
          title:
          //  _isSearching
          //     ? TextField(
          //         style: AppStyles.styleCairoMedium15white(
          //           context,
          //         ),
          //         controller: _searchController,
          //         onChanged: _filterFavs,
          //         decoration: InputDecoration(
          //             hintText: 'سورة ...',
          //             hintStyle: AppStyles.styleCairoMedium15white(context),
          //             border: InputBorder.none,
          //             fillColor: Colors.white),
          //         autofocus: true,
          //       )
          //     : 
              Text(
                  'المفضلة',
                  style: AppStyles.styleDiodrumArabicbold20(context),
                ),
          actions: const [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: GestureDetector(
            //     onTap: _toggleSearch,
            //     child: Icon(_isSearching ? Icons.close : Icons.search),
            //   ),
            // )
          ]),
      body: _favorites.isNotEmpty
          ? ListView.builder(
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final favModel = _favorites[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListSurahsListeningPage(
                                reciter: favModel.reciter,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          '> ${favModel.reciter.name} ',
                          style: AppStyles.styleDiodrumArabicbold20(context)
                              .copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SurahListeningItem(
                        reciter: favModel.reciter,
                        index: favModel.surahIndex,
                        audioUrl: favModel.url,
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: Text(
                ' لا يوجد عناصر لعرضها',
                style: AppStyles.styleDiodrumArabicbold20(context),
              ),
            ),
    );
  }

  // List<TextSpan> _highlightQuery(
  //     String normalizedContent, String processedQuery, String originalContent) {
  //   List<TextSpan> spans = [];
  //   int startIndex = normalizedContent.indexOf(processedQuery);

  //   while (startIndex != -1) {
  //     spans.add(TextSpan(
  //         text: originalContent.substring(0, startIndex),
  //         style: AppStyles.styleUthmanicMedium30(context)));
  //     spans.add(TextSpan(
  //       text: originalContent.substring(
  //           startIndex, startIndex + processedQuery.length),
  //       style: AppStyles.styleUthmanicMedium30(context)
  //           .copyWith(color: Colors.red),
  //     ));
  //     originalContent =
  //         originalContent.substring(startIndex + processedQuery.length);
  //     normalizedContent =
  //         normalizedContent.substring(startIndex + processedQuery.length);
  //     startIndex = normalizedContent.indexOf(processedQuery);
  //   }

  //   spans.add(TextSpan(
  //       text: originalContent,
  //       style: AppStyles.styleUthmanicMedium30(context)));

  //   return spans;
  // }
}
