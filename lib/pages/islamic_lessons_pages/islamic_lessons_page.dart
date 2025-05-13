import 'dart:convert';
import 'package:azkar_app/model/audio_model.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../main.dart';
import '../../methods.dart';
import '../../widgets/islamic_lesson_listening_item.dart';
import '../../widgets/reciturs_item.dart';
import 'fav_islamic_lessons_page.dart';

class MainIslamicLessonsPage extends StatefulWidget {
  const MainIslamicLessonsPage({super.key});

  @override
  State<MainIslamicLessonsPage> createState() => _MainIslamicLessonsPageState();
}

class _MainIslamicLessonsPageState extends State<MainIslamicLessonsPage> {
  List<dynamic> audioList = [];
  ConnectivityResult _connectivityStatus = ConnectivityResult.none;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializePage();
  }

  Future<void> initializePage() async {
    await _checkInternetConnection();
    if (_connectivityStatus != ConnectivityResult.none) {
      await fetchAudios();
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
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

    if (_connectivityStatus == ConnectivityResult.none) {
      showMessage('لا يتوفر اتصال بالانترنت');
    }
  }

  Future<void> fetchAudios() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/audios/ar/ar/1/25/json'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        setState(() {
          audioList = data;
        });
      } else {
        showMessage('فشل في تحميل البيانات');
      }
    } catch (e) {
      showMessage('حدث خطأ أثناء جلب البيانات');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
            color: AppStyles.styleDiodrumArabicbold20(context).color),
        title: Text('الدروس الدينية',
            style: AppStyles.styleDiodrumArabicbold20(context)),
        backgroundColor: AppColors.kSecondaryColor,
      ),
      backgroundColor: AppColors.kPrimaryColor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : audioList.isEmpty
              ? const Center(
                  child: Text(
                    'لا توجد بيانات متاحة',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: audioList.length + 1, // Extra item for favorites
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FavLessonPage()),
                          );
                        },
                        child: const RecitursItem(title: 'المفضلة'),
                      );
                    } else {
                      final item = audioList[index - 1]; // Adjust index
                      final title = item['title'];
                      final attachments = item['attachments'];
                      final description = item['prepared_by'][1]['title'] ??
                          item['prepared_by'][0]['title'];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListeningIslamicLessonsPage(
                                lessonName: title,
                                description: description,
                                audios: attachments,
                              ),
                            ),
                          );
                        },
                        child: RecitursItem(
                            title: title, description: description),
                      );
                    }
                  },
                ),
    );
  }
}

class ListeningIslamicLessonsPage extends StatefulWidget {
  const ListeningIslamicLessonsPage({
    super.key,
    required this.audios,
    required this.lessonName,
    required this.description,
  });
  final String description;
  final List audios;
  final String lessonName;

  @override
  State<ListeningIslamicLessonsPage> createState() =>
      _ListeningIslamicLessonsPageState();
}

class _ListeningIslamicLessonsPageState
    extends State<ListeningIslamicLessonsPage> {
    final List<AudioModel> _playList = [];

  @override
  void initState() {
    super.initState();
    _initPlaylist();
  }

  Future<void> _initPlaylist() async {

    for (int i = 0; i < widget.audios.length; i++) {
      _playList.add(AudioModel(
          audioURL: widget.audios[i]['url'],
          title: widget.audios[i]['description'],
          album: widget.description));
    }
    // Set up the audio source asynchronously.
    await globalAudioHandler.setAudioSourceWithPlaylist(
      playlist: _playList,
      index: 0, // Start from the first surah.
      album: widget.description,
      title: widget.audios[0]
          ['description'], // Assuming first surah is Al-Fatiha.

      artUri: null,
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
            color: AppStyles.styleDiodrumArabicbold20(context).color),
        title: Text(widget.lessonName,
            style: AppStyles.styleDiodrumArabicbold20(context)),
        backgroundColor: AppColors.kSecondaryColor,
      ),
      backgroundColor: AppColors.kPrimaryColor,
      body: widget.audios.isEmpty
          ? Center(
              child: Text('لا توجد ملفات صوتية متاحة',
                  style: AppStyles.styleDiodrumArabicMedium11(context)))
          : ListView.builder(
              itemCount: widget.audios.length,
              itemBuilder: (context, index) {
                final audio = widget.audios[index];
                return LessonListeningItem(
                  index: index,
                  totalLessons: widget.audios.length,
                  audioUrl: audio['url'],
                  title: audio['description'] ?? 'بدون عنوان',
                  description: widget.description,
                  // Callback to return audio URL for a given index.
                  // getAudioUrl: 
                  //    widget.audios[idx]['url'];
                   playlist: _playList,
                );
              },
            ),
    );
  }
}
