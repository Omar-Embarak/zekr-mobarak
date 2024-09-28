import 'package:flutter/material.dart';

import '../../constants.dart';

class ZekrPage extends StatelessWidget {
  final String zekerCategory;
  final List zekerList;
  ZekrPage({super.key, required this.zekerCategory, required this.zekerList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.kSecondaryColor,
        centerTitle: true,
        title: Text(
          zekerCategory,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
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
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            child: Center(
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w800),
                              ),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "من ${zekerCategory}",
                            style: TextStyle(
                                fontSize: 18, color: AppColors.kPrimaryColor),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        zekerList[index].text,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.white,
                          height: 2,
                          fontSize: 20,
                        ),
                      ),
                      Divider(
                        color: AppColors.kPrimaryColor,
                      ),
                      Text(
                        "التكرار : ${zekerList[index].count}",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.white,
                          height: 2,
                          fontSize: 20,
                        ),
                      ),
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
