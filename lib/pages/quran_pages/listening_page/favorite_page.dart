import 'package:azkar_app/constants.dart';
import 'package:azkar_app/widgets/surah_listening_item_widget.dart';
import 'package:flutter/material.dart';
import '../../../utils/app_style.dart';



class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kSecondaryColor,
        title: const Text(
          'المفضلة',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: AppColors.kPrimaryColor,
      body: ListView.builder(
        // itemCount: favItems.length,
        itemBuilder: (context, index) {
          // Use the SurahListeningItem widget to display the favorite item
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              // Text(favItems[index].reciterName,
              //     style: AppStyles.styleRajdhaniBold20(context).copyWith(
              //       color: Colors.white,
              //     )),
              // SurahListeningItem(
              //   surahIndex:
              //       index, // or map this to an actual Surah index if needed
              //   audioUrl: favItems[index].url,
              //   reciterName: favItems[index].reciterName,
              // ),
            ],
          );
        },
      ),
    );
  }
}
