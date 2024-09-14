import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../constants/colors.dart';
import '../../widgets/reciturs_item.dart';

class DroosPage extends StatefulWidget {
  const DroosPage({super.key});

  @override
  State<DroosPage> createState() => _DroosPageState();
}

class _DroosPageState extends State<DroosPage> {
  List audios = [];
  String titles = '';
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
        audios = data[0]['attachments'];
        titles = data[0]['title'];
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
        body: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DroosListeningPage(
                    audios: audios,
                  ),
                ));
          },
          child: RecitursItem(
            reciter: titles,
          ),
        ));
  }
}

class DroosListeningPage extends StatelessWidget {
  const DroosListeningPage({super.key, required this.audios});
  final List audios;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: audios.length,
        itemBuilder: (context, index) {
          final audio = audios[index];
          return ListTile(
            title: Text(audio['description']),
            onTap: () {
              print(audio['url']); // طباعة الرابط عند النقر
            },
          );
        },
      );
  }
}
