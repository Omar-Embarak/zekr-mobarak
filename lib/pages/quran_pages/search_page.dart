import 'package:azkar_app/constants.dart';
import 'package:azkar_app/methods.dart';
import 'package:azkar_app/pages/quran_pages/surah_page.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

import '../../quran_text_no_diacritics.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final FocusNode _searchFocusNode = FocusNode(); // FocusNode for the TextField
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];

  @override
  void initState() {
    super.initState();

    // Request focus when the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    // Dispose of the FocusNode to avoid memory leaks
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _search(String query) {
    try {
      // Normalize the query
      String processedQuery = normalizeArabic(query);
      List<Map<String, dynamic>> results = [];

      // Iterate over quranText to find matches
      for (var verse in quranText) {
        String verseContent = normalizeArabic(verse['content']);
        if (verseContent.contains(processedQuery)) {
          results.add({
            "surah": verse['surah_number'],
            "verse": verse['verse_number'],
            "content": verse['content'], // Include the original content
          });
        }
      }

      setState(() {
        searchResults = results;
      });
    } catch (e) {
      showMessage("حدث خطأ أثناء البحث: $e");
      setState(() {
        searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.kPrimaryColor,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: AppStyles.styleCairoMedium15white(context),
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.search,
                    color: AppStyles.styleRajdhaniBold20(context).color,
                  ),
                  labelText: "البحث",
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueGrey,
                      width: 1.0,
                    ),
                  ),
                ),
                onChanged: _search,
              ),
            ),
            if (searchResults.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "عدد النتائج: ${searchResults.length}",
                    style: AppStyles.styleAmiriMedium11(context),
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final result = searchResults[index];
                  return _buildSearchItem(result);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchItem(Map<String, dynamic> result) {
    final verseContent = result['content'];
    final processedQuery = normalizeArabic(_searchController.text);
    final normalizedContent = normalizeArabic(verseContent);

    final spans =
        _highlightQuery(normalizedContent, processedQuery, verseContent);

    return ListTile(
      title: RichText(
        text: TextSpan(
          style: AppStyles.styleUthmanicMedium30(context),
          children: spans,
        ),
      ),
      subtitle: Text(
        'سورة: ${quran.getSurahNameArabic(result['surah'])}, آية: ${result['verse']}',
        style: AppStyles.styleCairoMedium15white(context),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SurahPage(
            pageNumber: quran.getPageNumber(
              result['surah'],
              result['verse'],
            ),
          ),
        ));
      },
    );
  }

  List<TextSpan> _highlightQuery(
      String normalizedContent, String processedQuery, String originalContent) {
    List<TextSpan> spans = [];
    int startIndex = normalizedContent.indexOf(processedQuery);

    while (startIndex != -1) {
      spans.add(TextSpan(
          text: originalContent.substring(0, startIndex),
          style: AppStyles.styleUthmanicMedium30(context)));
      spans.add(TextSpan(
        text: originalContent.substring(
            startIndex, startIndex + processedQuery.length),
        style: AppStyles.styleUthmanicMedium30(context)
            .copyWith(color: Colors.red),
      ));
      originalContent =
          originalContent.substring(startIndex + processedQuery.length);
      normalizedContent =
          normalizedContent.substring(startIndex + processedQuery.length);
      startIndex = normalizedContent.indexOf(processedQuery);
    }

    spans.add(TextSpan(
        text: originalContent,
        style: AppStyles.styleUthmanicMedium30(context)));

    return spans;
  }
}
