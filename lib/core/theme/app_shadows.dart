import 'package:flutter/material.dart';

class AppShadows {
  static const Color _shadowColor = Color(0x1F000000); // Black with 12% opacity

  static const List<BoxShadow> sm = [
    BoxShadow(color: _shadowColor, offset: Offset(0, 1), blurRadius: 2),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(color: _shadowColor, offset: Offset(0, 2), blurRadius: 4),
    BoxShadow(
      color: _shadowColor,
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(
      color: _shadowColor,
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: _shadowColor,
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0A000000), // Very light shadow
      offset: Offset(0, 4),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];
}
