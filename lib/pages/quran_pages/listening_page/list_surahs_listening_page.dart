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

  void updateTappedSurahName(int surahIndex) {
    setState(() {
      tappedSurahName =
          'تشغيل سورة ${quran.getSurahNameArabic(surahIndex + 1)} الآن';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kSecondaryColor,
      appBar: AppBar(
        title: const Text('استماع القران الكريم'),
        backgroundColor: AppColors.kPrimaryColor,
        leading:
            const IconConstrain(height: 24, imagePath: Assets.imagesSearch),
      ),
      body: BlocConsumer<AddFavSurahItemCubit, AddFavSurahItemState>(
        listener: (context, state) {
          if (state is AddFavSurahItemFailure) {
            print(
                'error while adding the surah to favourite page: ${state.errMessage }');
          }
          if (state is AddFavSurahItemSuccess) {
            log('added succesfully');
          }
          ;
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
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: 114,
                    itemBuilder: (context, index) {
                      final audioUrl = widget.zeroPadding
                          ? '${widget.audioBaseUrl}${(index + 1).toString().padLeft(3, '0')}.mp3'
                          : '${widget.audioBaseUrl}${index + 1}.mp3';

                      return SurahListeningItem(
                        reciterName: widget.reciterName,
                        surahIndex: index,
                        audioUrl: audioUrl,
                        onSurahTap: updateTappedSurahName,
                      );
                    },
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
