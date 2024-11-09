import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'book_mark_provider.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookmarkProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          itemCount: provider.bookmarks.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(provider.bookmarks[index]),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => provider.removeBookmark(index),
              ),
            );
          },
        );
      },
    );
  }
}
