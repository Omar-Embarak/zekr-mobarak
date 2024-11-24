import 'dart:convert';
import 'package:azkar_app/utils/app_style.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../methods.dart';
import '../../widgets/dars_listening_item.dart';
import '../../widgets/reciturs_item.dart';

class DroosPage extends StatefulWidget {
  const DroosPage({super.key});

  @override
  State<DroosPage> createState() => _DroosPageState();
}

class _DroosPageState extends State<DroosPage> {
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
    setState(() {
      isLoading = false;
    });
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
        title: Text(
          'الدروس الدينية',
          style: AppStyles.styleCairoBold20(context),
        ),
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
                  itemCount: audioList.length,
                  itemBuilder: (context, index) {
                    final item = audioList[index];
                    final title = item['title'];
                    final attachments = item['attachments'];
                    final description = item['prepared_by'][1]['title'] ??
                        item['prepared_by'][0]['title'];
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
                        Title: title,
                        description: description,
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
      body: audios.isEmpty
          ? const Center(
              child: Text(
                'لا توجد ملفات صوتية متاحة',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: audios.length,
              itemBuilder: (context, index) {
                final audio = audios[index];
                return DarsListeningItem(
                  audioUrl: audio['url'],
                  title: audio['description'] ?? 'بدون عنوان',
                );
              },
            ),
    );
  }
}
