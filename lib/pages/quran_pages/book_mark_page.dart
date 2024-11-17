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
        // Debugging: Display total bookmarks count
        print('Total bookmarks: ${provider.bookmarks.length}');

        // Check if bookmarks are empty
        if (provider.bookmarks.isEmpty) {
          return const Center(
            child: Text(
              'No bookmarks available.',
              style: TextStyle(color: AppColors.kSecondaryColor),
            ),
          );
        }

        // Display bookmarks
        return ListView.builder(
          itemCount: provider.bookmarks.length,
          itemBuilder: (context, index) {
            final bookmark = provider.bookmarks[index];
            print('Rendering bookmark: ${bookmark.surahName}');

            return Card(
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
                  style: const TextStyle(color: AppColors.kSecondaryColor),
                ),
                subtitle: Text(
                  'صفحة ${bookmark.pageNumber}',
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => provider.removeBookmark(index),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
