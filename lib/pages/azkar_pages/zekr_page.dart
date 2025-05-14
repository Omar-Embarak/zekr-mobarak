import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants.dart';
import '../../cubit/fav_zekr_cubit/fav_zekr_cubit.dart';
import '../../utils/app_images.dart';
import '../../utils/app_style.dart';

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
              onPressed: ()async {         await context
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

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.kSecondaryColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Center(
                                  child: Text(
                                    "${index + 1}",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  "من ${zekerCategory}",
                                  style: AppStyles.styleRajdhaniBoldOrange20(
                                      context),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            text ?? 'No text available',
                            textAlign: TextAlign.justify,
                            style: AppStyles.styleDiodrumArabicbold20(context),
                          ),
                          Divider(color: AppColors.kPrimaryColor),
                          Text(
                            "التكرار : ${count ?? 'N/A'}",
                            textAlign: TextAlign.justify,
                            style: AppStyles.styleDiodrumArabicbold20(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )),
      );
    });
  }
}
