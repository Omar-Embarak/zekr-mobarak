import 'package:azkar_app/model/quran_models/reciters_model.dart';
import 'package:flutter/material.dart';
import 'package:azkar_app/constants/colors.dart';
import 'package:azkar_app/utils/app_style.dart';
import '../../../widgets/reciturs_item.dart';
import 'list_surahs_listening_page.dart';

class MurattalPage extends StatelessWidget {
  MurattalPage({super.key});
  final List<RecitersModel> reciters = [
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/abdul_baset/murattal/',
      name: 'عبد الباسط عبد الصمد',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/qdc/abdurrahmaan_as_sudais/murattal/',
      name: 'عبدالرحمن السديس',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/abu_bakr_shatri/murattal/',
      name: 'ابو بكر الشاطري',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/hani_ar_rifai/murattal/',
      name: 'هاني الرفاعي',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/khalil_al_husary/murattal/',
      name: 'خليل الحصري',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/khalil_al_husary/muallim/',
      name: 'خليل الحصري - المعلم',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/mishari_al_afasy/murattal/',
      name: 'مشاري العفاسي',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/siddiq_minshawi/murattal/',
      name: 'صديق المنشاوي',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/saud_ash-shuraym/murattal/',
      name: 'سعود الشريم',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abdul_muhsin_alqasim/',
      name: 'عبدالمحسن القاسم',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/sa3d_al-ghaamidi/complete//',
      name: 'سعد الغامدي',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/thubaity//',
      name: 'عبدالباري بن عواض الثبيتي',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/sahl_yaaseen/',
      name: 'سهل ياسين',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/salaah_bukhaatir//',
      name: 'صلاح بوخاطر',
      zeroPaddingSurahNumber: true,
    ), RecitersModel(
      url: 'https://download.quranicaudio.com/quran/ahmed_ibn_3ali_al-3ajamy//',
      name: 'أحمد بن علي العجمي',
      zeroPaddingSurahNumber: true,
    ),
 RecitersModel(
      url: 'https://download.quranicaudio.com/quran/sodais_and_shuraim//',
      name: 'السديس والشريم',
      zeroPaddingSurahNumber: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.kSecondaryColor,
        title: Text(
          'القران المرتل',
          style: AppStyles.styleCairoBold20(context),
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
                    audioBaseUrl: reciters[index].url,
                    reciterName: reciters[index].name,
                    zeroPadding: reciters[index].zeroPaddingSurahNumber,
                  ),
                ),
              );
            },
            child: RecitursItem(
              reciter: reciters[index].name,
            ),
          );
        },
      ),
    );
  }
}
