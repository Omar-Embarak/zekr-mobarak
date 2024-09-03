import 'package:flutter/material.dart';

import '../utils/app_style.dart';

class ListeningButtons extends StatelessWidget {
  const ListeningButtons({
    super.key,
    required this.color,
    required this.builder,
    required this.buttonText,
  });
  final String buttonText;
  final Color color;
  final Widget Function(BuildContext) builder;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 128, vertical: 16),
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(7), color: color),
          child: Text(buttonText, style: AppStyles.styleCairoBold20(context)),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: builder,
            ));
      },
    );
  }
}
