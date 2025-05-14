import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:azkar_app/widgets/reciturs_item.dart';
import '../../constants.dart';
import '../../cubit/fav_zekr_cubit/fav_zekr_cubit.dart';
import 'zekr_page.dart';

class FavAzkarPage extends StatelessWidget {
  const FavAzkarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppStyles.styleDiodrumArabicbold20(context).color,
        ),
        title: Text(
          'أذكاري المفضلة',
          style: AppStyles.styleDiodrumArabicbold20(context),
        ),
        centerTitle: true,
        backgroundColor: AppColors.kSecondaryColor,
      ),
      backgroundColor: AppColors.kPrimaryColor,
      body: BlocBuilder<FavZekrCubit, FavZekrState>(
        builder: (context, state) {
          if (state is FavZekrLoading) {
            return const Center(child: CircularProgressIndicator());
          } 
          else if (state is FavZekrLoaded) {
            final favorites = state.favorites;
            if (favorites.isEmpty) {
              return Center(
                child: Text(
                  'لم يتم اضافة اذكار مفضلة بعد.',
                  style: AppStyles.styleDiodrumArabicbold20(context),
                ),
              );
            }
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: RecitursItem(
                    title: favorites[index]['category'],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ZekrPage(
                          zekerCategory: favorites[index]['category'],
                          zekerList: favorites[index]['zekerList'],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is FavZekrError) {
            return Center(
              child: Text(
                state.message,
                style: AppStyles.styleDiodrumArabicbold20(context),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}