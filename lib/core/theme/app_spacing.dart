import 'package:flutter/material.dart';

class AppSpacing {
  // Constant Spacing
  static const double p4 = 4.0;
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p32 = 32.0;
  static const double p40 = 40.0;
  static const double p48 = 48.0;
  static const double p64 = 64.0;

  // Gaps (SizedBox)
  static const Widget gap4 = SizedBox(height: p4, width: p4);
  static const Widget gap8 = SizedBox(height: p8, width: p8);
  static const Widget gap12 = SizedBox(height: p12, width: p12);
  static const Widget gap16 = SizedBox(height: p16, width: p16);
  static const Widget gap20 = SizedBox(height: p20, width: p20);
  static const Widget gap24 = SizedBox(height: p24, width: p24);
  static const Widget gap32 = SizedBox(height: p32, width: p32);
  static const Widget gap48 = SizedBox(height: p48, width: p48);

  // Slivers
  static const Widget sliverGap4 = SliverToBoxAdapter(child: gap4);
  static const Widget sliverGap8 = SliverToBoxAdapter(child: gap8);
  static const Widget sliverGap16 = SliverToBoxAdapter(child: gap16);
  static const Widget sliverGap24 = SliverToBoxAdapter(child: gap24);
  static const Widget sliverGap32 = SliverToBoxAdapter(child: gap32);

  // Insets
  static const EdgeInsets edgeInsetsAll4 = EdgeInsets.all(p4);
  static const EdgeInsets edgeInsetsAll8 = EdgeInsets.all(p8);
  static const EdgeInsets edgeInsetsAll16 = EdgeInsets.all(p16);
  static const EdgeInsets edgeInsetsAll24 = EdgeInsets.all(p24);

  static const EdgeInsets edgeInsetsH16 = EdgeInsets.symmetric(horizontal: p16);
  static const EdgeInsets edgeInsetsV16 = EdgeInsets.symmetric(vertical: p16);

  static const EdgeInsets edgeInsetsH24 = EdgeInsets.symmetric(horizontal: p24);
  static const EdgeInsets edgeInsetsV24 = EdgeInsets.symmetric(vertical: p24);
}
