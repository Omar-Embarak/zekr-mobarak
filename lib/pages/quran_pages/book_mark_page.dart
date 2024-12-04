import 'package:azkar_app/pages/quran_pages/surah_page.dart';
import 'package:azkar_app/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'book_mark_provider.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookmarkProvider>(
      builder: (context, provider, child) {
        // Check if bookmarks are empty
        if (provider.bookmarks.isEmpty) {
          return  Center(
            child: Text(
              'لا يوجد صفحات محفوظة',
              style: TextStyle(color: AppColors.kSecondaryColor),
            ),
          );
        }

        // Display bookmarks
        return ListView.builder(
          itemCount: provider.bookmarks.length,
          itemBuilder: (context, index) {
            final bookmark = provider.bookmarks[index];

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SurahPage(
                        pageNumber: provider.bookmarks[index].pageNumber)));
              },
              child: Card(
                elevation: 3,
                margin: const EdgeInsets.only(top: 8, right: 10, left: 8),
                child: ListTile(
                  leading: Image.asset(
                    Assets.imagesBookmark,
                    height: 50,
                    width: 50,
                  ),
                  title: Text(
                    'سورة ${bookmark.surahName}',
                    style:  TextStyle(color: AppColors.kSecondaryColor),
                  ),
                  subtitle: Text(
                    'صفحة ${bookmark.pageNumber}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await provider.removeBookmark(index);
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
