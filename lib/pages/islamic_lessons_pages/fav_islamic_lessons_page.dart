import 'package:azkar_app/pages/islamic_lessons_pages/fav_islamic_lessons_provider.dart';
import 'package:azkar_app/widgets/islamic_lesson_listening_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../database_helper.dart';
import '../../main.dart';
import '../../model/audio_model.dart';
import '../../model/fav_dars_model.dart';
import '../../utils/app_style.dart';

class FavLessonPage extends StatefulWidget {
  const FavLessonPage({super.key});

  @override
  State<FavLessonPage> createState() => _FavLessonPageState();
}

class _FavLessonPageState extends State<FavLessonPage> {
  // List<FavDarsModel> _favorites = [];
  List<FavDarsModel> favorites = [];
  late DatabaseHelper _databaseHelper;
  List<AudioModel> playlist = [];
  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _loadFavorites();
    _initPlayList();
  }

  void _loadFavorites() async {
    try {
      favorites = await _databaseHelper.getFavsDars();
      if (mounted) {
        setState(() {});
        _initPlayList(); // Re-init playlist when favorites change
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  Future<void> _initPlayList() async {
    // Build the playlist from favorites
    playlist = favorites.map((fav) {
      return AudioModel(
        audioURL: fav.url, // Use the URL from FavDarsModel
        title: fav.name, // Use the name as the title
        album: 'الدروس المفضلة', // Or a more descriptive album name
      );
    }).toList();

    if (playlist.isNotEmpty) {
      // Set up the audio source asynchronously without auto-playing
      await globalAudioHandler.setAudioSourceWithPlaylist(
        playlist: playlist,
        index: 0, // Start from the first item
        album: "الدروس المفضلة", // Customize your album title if necessary
        title: favorites[0].name, // Customize the playlist title if needed
        artUri: null,
      );
    }
  }

  // Future<void> _initPlayList() async {
  //   try {
  //     final favs = await _databaseHelper.getFavsDars(); // Get favorites from DB
  //     playlist = favs.map((fav) {
  //       return AudioModel(
  //         audioURL: fav.url, // Use the URL from FavDarsModel
  //         title: fav.name, // Use the name as the title
  //         album: 'الدروس المفضلة', // Or a more descriptive album name
  //       );
  //     }).toList();

  //     if (playlist.isNotEmpty) {
  //       await globalAudioHandler.setAudioSourceWithPlaylist(
  //         playlist: playlist,
  //         index: 0, // Start from the first item
  //         album: "الدروس المفضلة", // Customize your album title if necessary
  //         title: favs[0].name, // Customize the playlist title if needed
  //         artUri: null,
  //       );
  //     } else {
  //       // Handle the case where no favorites are found
  //       showMessage(
  //           'لا يوجد عناصر في المفضلة.'); // Or any other suitable action
  //     }
  //   } catch (e) {
  //     // Handle database errors gracefully
  //     showMessage('خطا اثناء تحميل البيانات: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Call initPlayList when the page is built

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
            color: AppStyles.styleDiodrumArabicbold20(context).color),
        title:
            Text('المفضلة', style: AppStyles.styleDiodrumArabicbold20(context)),
        backgroundColor: AppColors.kSecondaryColor,
      ),
      backgroundColor: AppColors.kPrimaryColor,
      body: Consumer<FavDarsProvider>(builder: (context, provider, child) {
        if (favorites.isEmpty) {
          return Center(
            child: Text('لا يوجد دروس محفوظة',
                style: AppStyles.styleDiodrumArabicbold20(context)),
          );
        } else {
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              return LessonListeningItem(
                playlist: playlist,
                index: index,
                totalLessons: playlist.length,
                audioUrl: favorites[index].url,
                title: favorites[index].name,
                description: '', // adjust if you have a description field
                // getAudioUrl:favorites[index].url;
              );
            },
          );
        }
      }),
    );
  }
}
