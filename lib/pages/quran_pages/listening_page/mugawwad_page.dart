import 'package:azkar_app/model/quran_models/reciters_model.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../utils/app_style.dart';
import '../../../widgets/reciturs_item.dart';
import 'list_surahs_listening_page.dart';

// ignore: must_be_immutable
class MugawwadPage extends StatelessWidget {
  const MugawwadPage({super.key});
  final List<RecitersModel> reciters = const [
    RecitersModel(
        url: 'https://download.quranicaudio.com/qdc/abdul_baset/mujawwad/',
        name: 'عبد الباسط عبد الصمد',
        zeroPaddingSurahNumber: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.kSecondaryColor,
        title: Text(
          'القران المجود',
          style: AppStyles.styleDiodrumArabicbold20(context),
        ),
      ),
      body: ListView.builder(
        itemCount: reciters.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListSurahsListeningPage(
                    reciter: reciters[index],
                  ),
                ),
              );
            },
            child: RecitursItem(
              title: reciters[index].name,
            ),
          );
        },
      ),
    );
  }
}
