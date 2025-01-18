

import 'package:flutter/material.dart';

class HizbImage extends StatelessWidget {
  const HizbImage({
    super.key,
    required this.quarterImages,
    required this.index,
  });

  final List<String> quarterImages;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Stack(
        children: [
          Image.asset(
            quarterImages[index % quarterImages.length],
            fit: BoxFit.cover,
          ),
          Center(
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
