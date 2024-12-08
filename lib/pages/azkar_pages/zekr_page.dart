import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class ZekrPage extends StatelessWidget {
  final String zekerCategory;
  final List zekerList;
  const ZekrPage(
      {super.key, required this.zekerCategory, required this.zekerList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.kSecondaryColor,
        centerTitle: true,
        title: Text(
          zekerCategory,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
          itemCount: zekerList.length,
          itemBuilder: (context, index) {
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
                                    fontSize: 18, fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            // Ensures the text wraps properly within the available space
                            child: Text(
                              "من $zekerCategory",
                              style:
                                  AppStyles.styleRajdhaniBoldOrange20(context),
                              maxLines: 2, // Limit to 2 lines
                              overflow: TextOverflow
                                  .ellipsis, // Add ellipsis when overflowed
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(zekerList[index].text,
                          textAlign: TextAlign.justify,
                          style: AppStyles.styleCairoBold20(context)),
                      Divider(
                        color: AppColors.kPrimaryColor,
                      ),
                      Text("التكرار : ${zekerList[index].count}",
                          textAlign: TextAlign.justify,
                          style: AppStyles.styleCairoBold20(context)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
