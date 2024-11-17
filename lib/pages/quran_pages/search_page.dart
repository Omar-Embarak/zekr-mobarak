import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];

  void _search(String query) {
    setState(() {
      searchResults = quran.searchWords([query])['result'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
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
              onSubmitted: _search,
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
                    'Surah: ${quran.getSurahName(result['surah'])}, Ayah: ${result['verse']}',
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
