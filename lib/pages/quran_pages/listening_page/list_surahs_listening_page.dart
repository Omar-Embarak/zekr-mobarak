import 'dart:developer';
import 'package:azkar_app/cubit/add_fav_surahcubit/add_fav_surah_item_cubit.dart';
import 'package:azkar_app/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:quran/quran.dart' as quran;
import '../../../constants.dart';
import '../../../widgets/icon_constrain_widget.dart';
import '../../../widgets/surah_listening_item_widget.dart';

class ListSurahsListeningPage extends StatefulWidget {
  final String audioBaseUrl;
  final String reciterName;
  final bool zeroPadding;

  const ListSurahsListeningPage({
    super.key,
    required this.audioBaseUrl,
    required this.reciterName,
    required this.zeroPadding,
  });

  @override
  State<ListSurahsListeningPage> createState() =>
      _ListSurahsListeningPageState();
}

class _ListSurahsListeningPageState extends State<ListSurahsListeningPage> {
  String? tappedSurahName;
  final TextEditingController _searchController = TextEditingController();
  List<int> filteredSurahs =
      List.generate(114, (index) => index + 1); // All surahs by default
  bool _isSearching = false;

  void updateTappedSurahName(int surahIndex) {
    setState(() {
      tappedSurahName =
          'تشغيل سورة ${quran.getSurahNameArabic(surahIndex + 1)} الآن';
    });
  }

  void _filterSurahs(String query) {
    setState(() {
      filteredSurahs = List.generate(114, (index) => index + 1)
          .where((index) =>
              quran.getSurahNameArabic(index).contains(query) ||
              quran
                  .getSurahName(index)
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching; // Toggle search visibility
      if (!_isSearching) {
        _searchController.clear();
        _filterSurahs(''); // Reset the list when closing search
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kSecondaryColor,
      appBar: AppBar(
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  onChanged: _filterSurahs,
                  decoration: const InputDecoration(
                    hintText: 'إبحث عن سورة ...',
                    border: InputBorder.none,
                  ),
                  autofocus: true, // Focus automatically when search is toggled
                )
              : const Text('استماع القران الكريم'),
          backgroundColor: AppColors.kPrimaryColor,
          actions: [
            GestureDetector(
              onTap: _toggleSearch,
              child: _isSearching
                  ? const Icon(Icons.close) // Wrap IconData in an Icon widget
                  : const IconConstrain(
                      height: 30,
                      imagePath: Assets.imagesSearch,
                    ),
            )
          ]),
      body: BlocConsumer<AddFavSurahItemCubit, AddFavSurahItemState>(
        listener: (context, state) {
          if (state is AddFavSurahItemFailure) {
            print(
                'error while adding the surah to favourite page: ${state.errMessage}');
          }
          if (state is AddFavSurahItemSuccess) {
            log('added successfully');
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state is AddFavSurahItemLoading ? true : false,
            child: Column(
              children: [
                // Non-scrollable content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        widget.reciterName,
                        style: AppStyles.styleCairoBold20(context),
                      ),
                      if (tappedSurahName != null)
                        Text(
                          tappedSurahName!,
                          style: AppStyles.styleCairoMedium15(context)
                              .copyWith(color: Colors.white),
                        ),
                    ],
                  ),
                ),

                // Scrollable list of surahs
                Expanded(
                  child: filteredSurahs.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: filteredSurahs.length,
                          itemBuilder: (context, index) {
                            final surahIndex = filteredSurahs[index] -
                                1; // Adjusting to 0-based index
                            final audioUrl = widget.zeroPadding
                                ? '${widget.audioBaseUrl}${(surahIndex + 1).toString().padLeft(3, '0')}.mp3'
                                : '${widget.audioBaseUrl}${surahIndex + 1}.mp3';

                            return SurahListeningItem(
                              reciterName: widget.reciterName,
                              surahIndex: surahIndex,
                              audioUrl: audioUrl,
                              onSurahTap: updateTappedSurahName,
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            'اسم السورة غير صحيح.',
                            style: AppStyles.styleCairoBold20(context),
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
