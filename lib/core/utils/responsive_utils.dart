import 'package:flutter/material.dart';

/// Utilitaire pour la gestion du responsive design dans l'application.
///
/// Permet de détecter le type d'appareil (Mobile, Tablette, Desktop) en fonction
/// de la largeur de l'écran et d'adapter les valeurs d'UI en conséquence.
class ResponsiveUtils {
  /// Seuil de largeur pour considérer un appareil comme mobile.
  static const double mobileBreakpoint = 600;

  /// Seuil de largeur pour considérer un appareil comme tablette.
  static const double tabletBreakpoint = 900;

  /// Retourne [true] si l'écran est de taille mobile.
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  /// Retourne [true] si l'écran est de taille tablette.
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < tabletBreakpoint;

  /// Retourne [true] si l'écran est de taille bureau (Desktop).
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  /// Sélectionne dynamiquement une valeur de type [T] en fonction du breakpoint actuel.
  static T valueByBreakpoint<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    }
    if (isTablet(context)) {
      return tablet ?? mobile;
    }
    return mobile;
  }
}
