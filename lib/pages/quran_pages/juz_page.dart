import 'package:azkar_app/constants.dart';
import 'package:azkar_app/utils/app_images.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/material.dart';

import '../../methods.dart';

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
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await loadJSONDataList('assets/quranjson/juz.json');
    setState(() {
      juzData = data; // Update state with loaded data
    });
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
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.kSecondaryColor,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey),
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
                bottom: BorderSide(color: Colors.grey),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
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
                const SizedBox(width: 10),
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
