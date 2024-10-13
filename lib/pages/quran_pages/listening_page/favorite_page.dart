import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../database_helper.dart';
import '../../../model/quran_models/fav_model.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_style.dart';
import '../../../widgets/icon_constrain_widget.dart';
import '../../../widgets/surah_listening_item_widget.dart';
import 'package:quran/quran.dart' as quran;

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late List<FavModel> _favorites;
  late DatabaseHelper _databaseHelper;
  final TextEditingController _searchController = TextEditingController();
  List<FavModel> filteredFavs = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _loadFavorites(); // Load favorites initially
  }

  void _loadFavorites() async {
    List<FavModel> favorites = await _databaseHelper.getFavorites();
    setState(() {
      _favorites = favorites;
      filteredFavs = favorites;
    });
  }

  void _filterFavs(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        filteredFavs = _favorites; // Show all favorites if query is empty
        return;
      }

      // Normalize the query by trimming leading/trailing spaces
      final normalizedQuery = query.trim();

      // Ignore certain prefixes
      if (normalizedQuery == 'سورة' ||
          normalizedQuery == 'س' ||
          normalizedQuery == 'سو' ||
          normalizedQuery == 'سور') {
        filteredFavs =
            _favorites; // Show all favorites if ignored prefixes are entered
        return;
      }

      filteredFavs = _favorites.where((fav) {
        final surahName = quran.getSurahNameArabic(fav.surahIndex + 1).trim();

        // Check if the surah name contains the normalized query
        return surahName.contains(normalizedQuery);
      }).toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filterFavs('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
          backgroundColor: AppColors.kSecondaryColor,
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  onChanged: _filterFavs,
                  decoration: const InputDecoration(
                      hintText: 'سورة ...',
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                      fillColor: Colors.white),
                  autofocus: true,
                )
              : Text(
                  'المفضلة',
                  style: AppStyles.styleCairoBold20(context),
                ),
          actions: [
            GestureDetector(
              onTap: _toggleSearch,
              child: _isSearching
                  ? const Icon(Icons.close)
                  : const IconConstrain(
                      height: 30,
                      imagePath: Assets.imagesSearch,
                    ),
            )
          ]),
      body: filteredFavs.isNotEmpty
          ? ListView.builder(
              itemCount: filteredFavs.length,
              itemBuilder: (context, index) {
                final favModel = filteredFavs[index];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Text(favModel.reciterName),
                    ),
                    SurahListeningItem(
                      surahIndex: favModel.surahIndex,
                      audioUrl: favModel.url,
                      reciterName: favModel.reciterName,
                    ),
                  ],
                );
              },
            )
          : Center(
              child: Text(
              ' لا يوجد عناصر في المفضلة بهذا الاسم',
              style: AppStyles.styleCairoBold20(context),
            )),
    );
  }
}
