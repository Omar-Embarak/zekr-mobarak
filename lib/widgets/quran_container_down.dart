import 'package:azkar_app/pages/quran_pages/book_mark_page.dart';
import 'package:azkar_app/pages/quran_pages/book_mark_provider.dart';
import 'package:azkar_app/pages/quran_pages/search_page.dart';
import 'package:azkar_app/widgets/icon_constrain_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/page_data.dart';
import '../constants.dart';
import '../model/book_mark_model.dart';
import '../pages/quran_pages/doaa_khatm_page.dart';
import '../pages/quran_pages/juz_page.dart';
import '../utils/app_images.dart';
import '../utils/app_style.dart';
import 'quran_containers_buttons_widget.dart';
import 'surahs_list_widget.dart';
import 'package:quran/quran.dart' as quran;

class QuranContainerDown extends StatefulWidget {
  const QuranContainerDown({super.key, required this.pageNumber});
  final int pageNumber;

  @override
  State<QuranContainerDown> createState() => _QuranContainerDownState();
}

class _QuranContainerDownState extends State<QuranContainerDown> {
  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);

    // Check if the current page is bookmarked
    final isBookmarked = bookmarkProvider.bookmarks
        .any((bookmark) => bookmark.pageNumber == widget.pageNumber);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      height: 136,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.kSecondaryColor.withOpacity(0.87),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Flexible(
                flex: 3,
                child: SizedBox(
                  height: 35,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SearchPage()));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      color: const Color(0x66CFAD65),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Hint text
                          Text(
                            'إبحث عن آية', // Search for an Ayah
                            style: AppStyles.styleDiodrumArabicMedium15(context)
                                .copyWith(color: Colors.white),
                          ),
                          // Icon
                          const IconConstrain(
                            height: 26,
                            imagePath: Assets.imagesSearch,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  height: 35,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        if (isBookmarked) {
                          final index = bookmarkProvider.bookmarks.indexWhere(
                            (bookmark) =>
                                bookmark.pageNumber == widget.pageNumber,
                          );
                          if (index != -1) {
                            await bookmarkProvider.removeBookmark(index);
                          }
                        } else {
                          final newBookmark = BookMarkModel(
                            surahName: quran.getSurahNameArabic(
                              pageData[widget.pageNumber - 1][0]['surah'],
                            ),
                            pageNumber: widget.pageNumber,
                          );
                          await bookmarkProvider.addBookmark(newBookmark);
                        }
                      },
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Row(
                          children: [
                            isBookmarked
                                ? const Icon(
                                    Icons.bookmark_outlined,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.bookmark_border_rounded,
                                    color: Colors.white,
                                  ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              isBookmarked ? 'إزالة العلامة' : 'حفظ علامة',
                              style:
                                  AppStyles.styleDiodrumArabicMedium15(context)
                                      .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              QuranContainerButtons(
                iconHeight: 15,
                iconPath: Assets.imagesSaveFilled,
                text: 'الإنتقال إلي العلامة',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BookmarksPage(),
                    ),
                  );
                },
              ),
              QuranContainerButtons(
                iconHeight: 18,
                iconPath: Assets.imagesPage,
                text: 'صفحة ${widget.pageNumber} ',
                onTap: () {},
              ),
            ],
          ),
          Row(
            children: [
              QuranContainerButtons(
                iconHeight: 10.07,
                iconPath: Assets.imagesIndex,
                text: 'الفهرس',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SurahListWidget(),
                    ),
                  );
                },
              ),
              QuranContainerButtons(
                iconHeight: 15.3,
                iconPath: Assets.imagesVector,
                text: 'الأجزاء',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const JuzListPage(),
                    ),
                  );
                },
              ),
              QuranContainerButtons(
                iconHeight: 16.4,
                iconPath: Assets.imagesHand,
                text: 'دعاء الختم',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DoaaKhatmPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
