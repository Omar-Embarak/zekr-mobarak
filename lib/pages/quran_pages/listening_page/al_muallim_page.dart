import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../model/quran_models/reciters_model.dart';
import '../../../utils/app_style.dart';
import '../../../widgets/reciturs_item.dart';
import 'list_surahs_listening_page.dart';

class AlMuallimPage extends StatelessWidget {
  const AlMuallimPage({super.key});

  final List<RecitersModel> reciters = const [
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/khalil_al_husary/muallim/',
      name: 'خليل الحصري - المعلم',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/husary_muallim//',
      name: 'خليل الحصري - المعلم  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/husary_muallim_kids_repeat//',
      name: 'خليل الحصري - المعلم مع الاطفال  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/siddiq_minshawi/kids_repeat/',
      name: 'صديق المنشاوي - المعلم مع الاطفال  ',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/alhusaynee_al3azazee_with_children//',
      name: 'الحسيني العزيزي -المعلم مع الاطفال ',
      zeroPaddingSurahNumber: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: AppStyles.styleCairoMedium15white(context).color),
        backgroundColor: AppColors.kSecondaryColor,
        title: Text(
          'القران المعلم',
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
