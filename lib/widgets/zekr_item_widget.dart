import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../utils/app_style.dart';

class ZekrItem extends StatelessWidget {
  const ZekrItem({
    super.key,
    required this.zekerCategory,
    required this.text,
    required this.count, required this.index,
  });

  final String zekerCategory;
  final String text;
  final int count;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.kSecondaryColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: .3,
            )
          ],
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
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      "من $zekerCategory",
                      style: AppStyles.styleRajdhaniBoldOrange20(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                text ,
                textAlign: TextAlign.justify,
                style: AppStyles.styleDiodrumArabicbold20(context),
              ),
              Divider(color: AppColors.kPrimaryColor),
              Text(
                "التكرار : $count",
                textAlign: TextAlign.justify,
                style: AppStyles.styleDiodrumArabicbold20(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
