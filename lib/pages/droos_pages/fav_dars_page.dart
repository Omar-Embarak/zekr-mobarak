import 'package:azkar_app/pages/droos_pages/fav_dars_provider.dart';
import 'package:azkar_app/widgets/dars_listening_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../utils/app_style.dart';

class FavDarsPage extends StatelessWidget {
  const FavDarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
            color: AppStyles.styleDiodrumArabicbold20(context).color),
        title:
            Text('المفضلة', style: AppStyles.styleDiodrumArabicbold20(context)),
        backgroundColor: AppColors.kSecondaryColor,
      ),
      backgroundColor: AppColors.kPrimaryColor,
      body: Consumer<FavDarsProvider>(builder: (context, provider, child) {
        if (provider.favsDars.isEmpty) {
          return Center(
            child: Text('لا يوجد دروس محفوظة',
                style: AppStyles.styleDiodrumArabicbold20(context)),
          );
        } else {
          return ListView.builder(
            itemCount: provider.favsDars.length,
            itemBuilder: (context, index) {
              final fav = provider.favsDars[index];
              return DarsListeningItem(
                darsIndex: index,
                totalLessons: provider.favsDars.length,
                audioUrl: fav.url,
                title: fav.name,
                description: '', // adjust if you have a description field
                getAudioUrl: (int idx) {
                  return provider.favsDars[idx].url;
                },
              );
            },
          );
        }
      }),
    );
  }
}
