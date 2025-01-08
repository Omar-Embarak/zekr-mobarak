import 'package:flutter/material.dart';

class NoScrollBeyondPhysics extends ScrollPhysics {
  final int maxPage;

  const NoScrollBeyondPhysics({super.parent, required this.maxPage});

  @override
  NoScrollBeyondPhysics applyTo(ScrollPhysics? ancestor) {
    return NoScrollBeyondPhysics(
      parent: buildParent(ancestor),
      maxPage: maxPage,
    );
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < 0 && position.pixels <= 0) {
      // Prevents scrolling before the first page
      return value - position.pixels;
    } else if (value > position.maxScrollExtent &&
        position.pixels >= position.maxScrollExtent) {
      // Prevents scrolling after the last allowed page
      return value - position.pixels;
    }
    return 0.0;
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    return true; // Allow user interaction for scrolling
  }
}
