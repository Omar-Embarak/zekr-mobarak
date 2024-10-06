import 'package:azkar_app/cubit/add_fav_surahcubit/add_fav_surah_item_cubit.dart';
import 'package:azkar_app/widgets/surah_listening_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants.dart';
import '../../../utils/app_style.dart';
import '../../../model/quran_models/fav_model.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        title: Text(
          'المفضلة',
          style: AppStyles.styleRajdhaniBold18(context)
              .copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.kSecondaryColor,
      ),
      body: BlocBuilder<AddFavSurahItemCubit, AddFavSurahItemState>(
        builder: (context, state) {
          if (state is AddFavSurahItemLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AddFavSurahItemSuccess) {
            final List<FavModel>? favItems = state.favSurahs;

            if (favItems == null || favItems.isEmpty) {
              return Center(
                child: Text(
                  'لا توجد عناصر مفضلة',
                  style: AppStyles.styleRajdhaniMedium18(context),
                ),
              );
            }

return ListView.builder(
  itemCount: favItems.length,
  
  itemBuilder: (context, index) {
    final favItem = favItems[index];

    return Dismissible(
      key: Key(favItem.surahName), 
      onDismissed: (direction) {
        BlocProvider.of<AddFavSurahItemCubit>(context).deleteFavSurah(index);
      },
      background: Container(color: Colors.red), 
      child: Column(
        children: [
          Text(
            favItem.reciterName,
            style: AppStyles.styleDiodrumArabicMedium15(context),
          ),
          SurahListeningItem(
            surahIndex: index,
            audioUrl: favItem.url,
            reciterName: favItem.reciterName,
            onSurahTap: (surahIndex) {
          
            },
          ),
        ],
      ),
    );
  },
);

          } else if (state is AddFavSurahItemFailure) {
            return Center(
              child: Text(
                'حدث خطأ ما: ${state.errorMessage}',
                style: AppStyles.styleRajdhaniMedium18(context),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
