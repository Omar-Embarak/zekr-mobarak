import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../constants.dart';
import '../../methods.dart';
import '../../utils/app_images.dart';
import '../../widgets/icon_constrain_widget.dart';
import '../../widgets/reciturs_item.dart';

class DroosPage extends StatefulWidget {
  const DroosPage({super.key});

  @override
  State<DroosPage> createState() => _DroosPageState();
}

class _DroosPageState extends State<DroosPage> {
  List<dynamic> audioList = [];

  @override
  void initState() {
    super.initState();
    fetchAudios();
  }

  Future<void> fetchAudios() async {
    final response = await http.get(
      Uri.parse(
          'https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/audios/ar/ar/1/25/json'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      setState(() {
        audioList = data; // Store all the data, not just the first index
      });
    } else {
      throw Exception('Failed to load audios');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الدروس الدينية',
          style: AppStyles.styleCairoBold20(context),
        ),
        backgroundColor: AppColors.kSecondaryColor,
      ),
      backgroundColor: AppColors.kPrimaryColor,
      body: audioList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: audioList.length,
              itemBuilder: (context, index) {
                final item = audioList[index]; // Fetch each individual item
                final title = item['title'];
                final attachments = item['attachments'];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DroosListeningPage(
                          darsName: title,
                          audios: attachments,
                        ),
                      ),
                    );
                  },
                  child: RecitursItem(
                    reciter: title,
                  ),
                );
              },
            ),
    );
  }
}

class DroosListeningPage extends StatelessWidget {
  const DroosListeningPage(
      {super.key, required this.audios, required this.darsName});

  final List audios;
  final String darsName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          darsName,
          style: AppStyles.styleCairoBold20(context),
        ),
        backgroundColor: AppColors.kSecondaryColor,
      ),
      backgroundColor: AppColors.kPrimaryColor,
      body: ListView.builder(
        itemCount: audios.length,
        itemBuilder: (context, index) {
          final audio = audios[index];
          return DarsListeningItem(
            audioUrl: audio['url'],
            title: audio['description'],
          );
        },
      ),
    );
  }
}

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
  bool isExpanded = false; // Control if the item is expanded
  bool isPlaying = false;
  bool isFavorite = false;
  Duration totalDuration = Duration.zero;
  Duration currentDuration = Duration.zero;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    initializeAudioPlayer(
        _audioPlayer, setTotalDuration, setCurrentDuration, setIsPlaying);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
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

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Align for long text
      children: [
        const SizedBox(width: 10),
        GestureDetector(
          onTap: toggleFavorite,
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
          onTap: () =>
              downloadDarsAudio(widget.audioUrl, widget.title, context),
          child: const IconConstrain(
              height: 30, imagePath: Assets.imagesDocumentDownload),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Future<void> downloadDarsAudio(
      String audioUrl, String title, BuildContext context) async {
    if (await requestPermission(Permission.storage)) {
      final dir = await getExternalStorageDirectory();
      if (dir != null) {
        String fileName = "$title.mp3";
        String filePath = "${dir.path}/$fileName";

        Dio dio = Dio();
        await dio.download(audioUrl, filePath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloaded $fileName')),
        );
      }
    }
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
    return Row(
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
          onPressed: () => togglePlayPause(
              _audioPlayer, isPlaying, widget.audioUrl, setIsPlaying),
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
