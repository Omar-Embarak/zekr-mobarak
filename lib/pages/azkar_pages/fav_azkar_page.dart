import 'package:azkar_app/database_helper.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:azkar_app/widgets/reciturs_item.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'zekr_page.dart'; // Import the ZekrPage file

class FavAzkarPage extends StatelessWidget {
  FavAzkarPage({super.key});
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: AppStyles.styleCairoBold20(context).color),
        title: Text(
          'أذكاري المفضلة',
          style: AppStyles.styleCairoBold20(context),
        ),
        centerTitle: true,
        backgroundColor: AppColors.kSecondaryColor,
      ),
      backgroundColor: AppColors.kPrimaryColor,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _databaseHelper.getFavsAzkar(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لم يتم اضافة عناصر مفضلة بعد.'));
          } else {
            final favorites = snapshot.data!;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: RecitursItem(
                    title: favorites[index]['category'],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ZekrPage(
                          zekerCategory: favorites[index]['category'],
                          zekerList: favorites[index]
                              ['zekerList'], // Pass decoded list
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
