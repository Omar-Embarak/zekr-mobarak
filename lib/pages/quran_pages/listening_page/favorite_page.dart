import 'package:azkar_app/widgets/surah_listening_item_widget.dart';
import 'package:flutter/material.dart';
import '../../../utils/app_style.dart';

class FavModel {
  String surahName;
  String reciterName;
  String url;
  FavModel({
    required this.url,
    required this.reciterName,
    required this.surahName,
  });
}

List<FavModel> favItems = [];

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'المفضلة',
          style: AppStyles.styleDiodrumArabicMedium15(context),
        ),
      ),
      body: ListView.builder(
        itemCount: favItems.length,
        itemBuilder: (context, index) {
          Column(
            
              children: [
                Text(favItems[index].reciterName),
                SurahListeningItem(surahIndex: surahIndex, audioUrl: audioUrl),
              ],
              );
        },
      ),
    );
  }
}
