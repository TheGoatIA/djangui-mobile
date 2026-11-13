// GÉNÉRÉ AUTOMATIQUEMENT par tool/release/release.mjs à chaque version publiée.
// Ne pas modifier à la main : la version et le build viennent de pubspec.yaml,
// l'édition (nom de constellation) de release/versions.json.

/// Informations de la version publiée affichées dans l'app (écran À propos).
class AppRelease {
  AppRelease._();

  /// Nom de l'édition (constellation), ex. « Orion » → « v4.1.0 - Orion Edition ».
  static const String edition = '';

  /// Libellé complet d'une version : « v4.1.0 - Orion Edition ».
  static String label(String version) =>
      edition.isEmpty ? 'v$version' : 'v$version - $edition Edition';
}
