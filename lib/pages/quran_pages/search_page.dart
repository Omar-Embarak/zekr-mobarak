import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:quran/quran_text.dart'; // To access quranText directly

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];

  // Function to remove diacritics (Tashkeel) from Arabic text
  String _removeTashkeel(String text) {
    return text.replaceAll(RegExp(r'[ًٌٍَُِّْ]'), '');
  }

  void _search(String query) {
    try {
      // Remove Tashkeel from the query
      String processedQuery = _removeTashkeel(query);
      List<Map<String, dynamic>> results = [];

      // Iterate over quranText to find matches
      for (var verse in quranText) {
        String verseContent = _removeTashkeel(verse['content']);
        if (verseContent.contains(processedQuery)) {
          results.add({
            "surah": verse['surah_number'],
            "verse": verse['verse_number'],
          });
        }
      }

      setState(() {
        searchResults = results;
      });
      log(searchResults.toString());
    } catch (e) {
      log("Error during search: $e");
      setState(() {
        searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Search",
                border: OutlineInputBorder(),
              ),
              onChanged: _search,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final result = searchResults[index];
                return ListTile(
                  title: Text(
                    quran.getVerse(
                      result['surah'],
                      result['verse'],
                    ),
                    style: const TextStyle(fontFamily: 'Amiri', fontSize: 16),
                  ),
                  subtitle: Text(
                    'Surah: ${quran.getSurahNameArabic(result['surah'])}, Ayah: ${result['verse']}',
                  ),
                  onTap: () {
                    Navigator.pop(context, result);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
