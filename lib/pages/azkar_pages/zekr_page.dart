import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants.dart';
import '../../cubit/fav_zekr_cubit/fav_zekr_cubit.dart';
import '../../utils/app_images.dart';
import '../../utils/app_style.dart';
import '../../widgets/zekr_item_widget.dart';

class ZekrPage extends StatelessWidget {
  // Changed to StatelessWidget
  final String zekerCategory;
  final List zekerList;

  const ZekrPage({
    super.key,
    required this.zekerCategory,
    required this.zekerList,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavZekrCubit, FavZekrState>(// Use BlocBuilder
        builder: (context, state) {
      final isFavorite = state is FavZekrLoaded
          ? state.favorites
              .any((element) => element['category'] == zekerCategory)
          : false;

      return Scaffold(
        backgroundColor: AppColors.kPrimaryColor,
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: AppStyles.styleDiodrumArabicbold20(context).color),
          backgroundColor: AppColors.kSecondaryColor,
          centerTitle: true,
          title: Text(
            zekerCategory,
            style: AppStyles.styleDiodrumArabicbold20(context),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await context
                    .read<FavZekrCubit>()
                    .toggleFavorite(zekerCategory, zekerList);
                // Trigger a fetch to update favorites list after toggling
                context.read<FavZekrCubit>().fetchFavorites();
              },
              icon: isFavorite
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : SvgPicture.asset(
                      height: 30,
                      Assets.imagesHeart,
                      placeholderBuilder: (context) => const Icon(Icons.error),
                      colorFilter: ColorFilter.mode(
                          AppStyles.themeNotifier.value == lightTheme
                              ? Colors.black
                              : Colors.white,
                          BlendMode.srcIn),
                    ),
            ),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(15),
            child: ListView.builder(
              itemCount: zekerList.length,
              itemBuilder: (context, index) {
                final item = zekerList[index];

                // Check if the item is a Map
                final text = item is Map<String, dynamic>
                    ? item['text'] as String?
                    : item.text;
                final count = item is Map<String, dynamic>
                    ? item['count'] as int?
                    : item.count;

                return ZekrItem(index: index,
                    zekerCategory: zekerCategory, text: text, count: count);
              },
            )),
      );
    });
  }
}

