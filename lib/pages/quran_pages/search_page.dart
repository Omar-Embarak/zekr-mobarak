import 'package:azkar_app/constants.dart';
import 'package:azkar_app/methods.dart';
import 'package:azkar_app/pages/quran_pages/surah_page.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
// import 'package:quran/quran_text.dart';

import '../../quran_text_no_diacritics.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final FocusNode _searchFocusNode = FocusNode(); // FocusNode for the TextField

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

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];

  void _search(String query) {
    try {
      // Normalize the query
      String processedQuery = normalizeArabic(query);
      List<Map<String, dynamic>> results = [];

      // Iterate over quranText to find matches
      for (var verse in quranText) {
        String verseContent = normalizeArabic(verse['content']);
        if (verseContent.contains(processedQuery)) {
          // Use contains here
          results.add({
            "surah": verse['surah_number'],
            "verse": verse['verse_number'],
            "content": verse[
                'content'], // Include the original content for highlighting
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
                  focusColor: Colors.blueGrey, // Focus color for other parts
                  suffixIcon: Icon(
                    Icons.search,
                    color: AppStyles.styleRajdhaniBold20(context).color,
                  ),
                  labelText: "البحث",
                  border: const OutlineInputBorder(), // Default border
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors
                          .blueGrey, // Blue-grey color for the focused state
                      width: 1.0, // Optional: Adjust the border thickness
                    ),
                  ),
                ),
                onChanged: _search,
              ),
            ),
            if (searchResults
                .isNotEmpty) // Show the count only when there are results
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
                  String verseContent = result['content'];
                  String normalizedContent = normalizeArabic(verseContent);
                  String processedQuery =
                      normalizeArabic(_searchController.text);

                  List<TextSpan> spans = [];
                  int startIndex = normalizedContent.indexOf(processedQuery);
                  if (startIndex != -1) {
                    spans.add(
                        TextSpan(text: verseContent.substring(0, startIndex)));
                    spans.add(TextSpan(
                      text: verseContent.substring(
                        startIndex,
                        startIndex + processedQuery.length,
                      ),
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ));
                    spans.add(TextSpan(
                        text: verseContent
                            .substring(startIndex + processedQuery.length)));
                  } else {
                    spans.add(TextSpan(text: verseContent));
                  }

                  return SearchItem(spans: spans, result: result);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchItem extends StatelessWidget {
  const SearchItem({
    super.key,
    required this.spans,
    required this.result,
  });

  final List<TextSpan> spans;
  final Map<String, dynamic> result;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: RichText(
        text: TextSpan(
          style: AppStyles.styleUthmanicMedium30(context),
          children: spans,
        ),
      ),
      subtitle: Text(
        'سورة: ${quran.getSurahNameArabic(result['surah'])}, آية: ${result['verse']}',
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
}
