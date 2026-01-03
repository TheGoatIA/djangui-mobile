import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const String fontFamily = 'Outfit';

  static TextTheme get lightTextTheme =>
      TextTheme(
        displayLarge: _baseStyle.copyWith(
          fontSize: 57,
          fontWeight: FontWeight.w700,
          height: 1.12,
          letterSpacing: -0.25,
        ),
        displayMedium: _baseStyle.copyWith(
          fontSize: 45,
          fontWeight: FontWeight.w700,
          height: 1.15,
          letterSpacing: 0,
        ),
        displaySmall: _baseStyle.copyWith(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          height: 1.25,
          letterSpacing: 0,
        ),

        headlineLarge: _baseStyle.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          height: 1.25,
          letterSpacing: 0,
        ),
        headlineMedium: _baseStyle.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          height: 1.28,
          letterSpacing: 0,
        ),
        headlineSmall: _baseStyle.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 1.33,
          letterSpacing: 0,
        ),

        titleLarge: _baseStyle.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          height: 1.27,
          letterSpacing: 0,
        ),
        titleMedium: _baseStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.5,
          letterSpacing: 0.15,
        ),
        titleSmall: _baseStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.43,
          letterSpacing: 0.1,
        ),

        bodyLarge: _baseStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          letterSpacing: 0.5,
        ),
        bodyMedium: _baseStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.43,
          letterSpacing: 0.25,
        ),
        bodySmall: _baseStyle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.33,
          letterSpacing: 0.4,
        ),

        labelLarge: _baseStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.43,
          letterSpacing: 0.1,
        ),
        labelMedium: _baseStyle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.33,
          letterSpacing: 0.5,
        ),
        labelSmall: _baseStyle.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          height: 1.45,
          letterSpacing: 0.5,
        ),
      ).apply(
        displayColor: AppColors.textPrimary,
        bodyColor: AppColors.textPrimary,
      );

  static TextTheme get darkTextTheme => lightTextTheme.apply(
    displayColor: AppColors.textPrimaryDark,
    bodyColor: AppColors.textPrimaryDark,
  );

  static const TextStyle _baseStyle = TextStyle(
    fontFamily: fontFamily,
    leadingDistribution: TextLeadingDistribution.even,
  );
}
