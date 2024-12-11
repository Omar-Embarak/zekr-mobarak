import 'package:azkar_app/database_helper.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../utils/app_style.dart';

class ZekrPage extends StatefulWidget {
  final String zekerCategory;
  final List zekerList;

  const ZekrPage({
    super.key,
    required this.zekerCategory,
    required this.zekerList,
  });

  @override
  State<ZekrPage> createState() => _ZekrPageState();
}

class _ZekrPageState extends State<ZekrPage> {
  bool isFavorite = false;
  final DatabaseHelper _database = DatabaseHelper();
  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  void _checkIfFavorite() async {
    isFavorite = await _database.isFavZekrExit(widget.zekerCategory);
    setState(() {});
  }

  void _toggleFavorite() async {
    if (isFavorite) {
      // Remove from favorites
      await _database.deleteFavAzkar(widget.zekerCategory);
    } else {
      // Add to favorites
      await _database.insertFavAzkar(
        widget.zekerCategory,
        widget.zekerList, // Pass the list to be saved
      );
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.kSecondaryColor,
        centerTitle: true,
        title: Text(
          widget.zekerCategory,
          style: AppStyles.styleCairoBold20(context),
        ),
        actions: [
          IconButton(
            onPressed: _toggleFavorite,
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(15),
          child: ListView.builder(
            itemCount: widget.zekerList.length,
            itemBuilder: (context, index) {
              final item = widget.zekerList[index];

              // Check if the item is a Map
              final text = item is Map<String, dynamic>
                  ? item['text'] as String?
                  : item.text;
              final count = item is Map<String, dynamic>
                  ? item['count'] as int?
                  : item.count;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.kSecondaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Center(
                                child: Text(
                                  "${index + 1}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                "من ${widget.zekerCategory}",
                                style: AppStyles.styleRajdhaniBoldOrange20(
                                    context),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          text ?? 'No text available',
                          textAlign: TextAlign.justify,
                          style: AppStyles.styleCairoBold20(context),
                        ),
                        Divider(color: AppColors.kPrimaryColor),
                        Text(
                          "التكرار : ${count ?? 'N/A'}",
                          textAlign: TextAlign.justify,
                          style: AppStyles.styleCairoBold20(context),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}
