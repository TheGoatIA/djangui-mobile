import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF10B981); // Emerald 500
  static const Color primaryDark = Color(0xFF059669); // Emerald 600
  static const Color primaryLight = Color(0xFF34D399); // Emerald 400
  static const Color secondary = Color(0xFF8B5CF6); // Violet 500
  static const Color accent = Color(0xFFF59E0B); // Amber 500

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF9FAFB)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient surfaceDarkGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Light Mode Neuters
  static const Color background = Color(0xFFF9FAFB); // Gray 50
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF111827); // Gray 900
  static const Color onSurface = Color(0xFF374151); // Gray 700
  static const Color outline = Color(0xFFE5E7EB); // Gray 200

  // Dark Mode Neuters
  static const Color primaryDarkTheme = Color(0xFF34D399);
  static const Color backgroundDark = Color(0xFF0F172A); // Slate 900
  static const Color surfaceDark = Color(0xFF1E293B); // Slate 800
  static const Color onBackgroundDark = Color(0xFFF1F5F9); // Slate 100
  static const Color onSurfaceDark = Color(0xFFCBD5E1); // Slate 300
  static const Color outlineDark = Color(0xFF334155); // Slate 700
  static const Color darkSurface = surfaceDark;

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Text Colors (Light)
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);

  // Text Colors (Dark)
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFFD1D5DB);
  static const Color textTertiaryDark = Color(0xFF9CA3AF);
}
