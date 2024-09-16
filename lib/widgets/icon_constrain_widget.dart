import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconConstrain extends StatelessWidget {
  const IconConstrain({
    super.key,
    required this.height,
    required this.imagePath,
  });

  final double height;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: height, // Ensure it's a square box for the icon
      child: Center(
        child: SvgPicture.asset(
          imagePath,
          placeholderBuilder: (context) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
