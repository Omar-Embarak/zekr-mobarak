import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'book_mark_provider.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookmarkProvider>(
      builder: (context, bookmarkProvider, child) {
        final bookmarks = bookmarkProvider.bookmarks;

        if (bookmarks.isEmpty) {
          return const Center(child: Text('لا توجد مراجع حالياً.'));
        }

        return ListView.builder(
          itemCount: bookmarks.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(bookmarks[index]),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  bookmarkProvider.removeBookmark(bookmarks[index]);
                },
              ),
            );
          },
        );
      },
    );
  }
}
