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
        title: Text(
          'المفضلة',
          style: AppStyles.styleCairoBold20(context),
        ),
        backgroundColor: AppColors.kSecondaryColor,
      ),
      backgroundColor: AppColors.kPrimaryColor,
      body: Consumer<FavDarsProvider>(builder: (context, provider, body) {
        if (provider.favsDars.isEmpty) {
          return Center(
            child: Text(
              'لا يوجد دروس محفوظة',
              style: AppStyles.styleCairoBold20(context),
            ),
          );
        } else {
          return ListView.builder(
              itemCount: provider.favsDars.length,
              itemBuilder: (context, index) {
                return DarsListeningItem(
                    audioUrl: provider.favsDars[index].url,
                    title: provider.favsDars[index].name);
              });
        }
      }),
    );
  }
}
