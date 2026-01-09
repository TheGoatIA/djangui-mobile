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
      color: Color(0x0F000000), // Slightly darker: 6% opacity
      offset: Offset(0, 4),
      blurRadius: 20,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x05000000), // Very soft outer glow: 2% opacity
      offset: Offset(0, 0),
      blurRadius: 1,
      spreadRadius: 1,
    ),
  ];

  static const List<BoxShadow> premium = [
    BoxShadow(
      color: Color(0x14000000), // 8% opacity
      offset: Offset(0, 10),
      blurRadius: 30,
      spreadRadius: -5,
    ),
    BoxShadow(
      color: Color(0x0A000000), // 4% opacity
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: -2,
    ),
  ];
}
