import 'dart:convert';
import 'package:azkar_app/constants.dart';
import 'package:azkar_app/utils/app_images.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JuzListPage extends StatefulWidget {
  const JuzListPage({super.key});

  @override
  State<JuzListPage> createState() => _JuzListPageState();
}

class _JuzListPageState extends State<JuzListPage> {
  List<dynamic> juzData = [];

  @override
  void initState() {
    super.initState();
    loadJuzData();
  }

  Future<void> loadJuzData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/quranjson/juz.json');
      final data = json.decode(response);
      setState(() {
        juzData = data;
      });
    } catch (e) {
      debugPrint('Error loading JSON: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      body: juzData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: juzData.length,
              itemBuilder: (context, index) {
                final juz = juzData[index];
                return Column(
                  children: [
                    Container(
                      width: double.infinity, // Takes full width of the screen
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.kSecondaryColor, // Background color
                        border: Border(
                          bottom:
                              BorderSide(color: Colors.grey), // Bottom border
                        ),
                      ),
                      child: Text(
                          'الجزء ${arabicOrdinals[int.parse(juz['juz_index']) - 1]}',
                          textAlign: TextAlign.center,
                          style: AppStyles.styleRajdhaniBold13(context)
                              .copyWith(color: Colors.white)),
                    ),
                    ..._buildHizbContainers(juz),
                  ],
                );
              },
            ),
    );
  }

  List<Widget> _buildHizbContainers(Map<String, dynamic> juz) {
    List<Widget> containers = [];
    List<String> imagesOFRob3 = [
      Assets.imagesHizp,
      Assets.imagesRob3,
      Assets.imagesHalf,
      Assets.images3rob3,
    ];
    for (int i = 1; i <= 8; i++) {
      final hizb = juz['hizb_$i'];
      if (hizb != null) {
        final start = hizb['start'];
        containers.add(
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: const Border(
                bottom: BorderSide(color: Colors.grey), // Only bottom border
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 60,
                  width: 60, // Ensure the image has a fixed width
                  child: Stack(
                    children: [
                      Image.asset(
                        imagesOFRob3[i % imagesOFRob3.length],
                        fit: BoxFit.cover,
                      ),
                      Center(
                        child: Text(
                          i % 4 == 0 ? '${i ~/ 4}' : '',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10), // Add spacing between image and text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${start['ayah_text']}...',
                        style: AppStyles.styleRajdhaniBold20(context)),
                    Row(
                      children: [
                        Text('آية: ${start['verse']}  '),
                        Text(
                          'سورة: ${start['surah']}',
                          style: AppStyles.styleRajdhaniBold18(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    }

    return containers;
  }
}
