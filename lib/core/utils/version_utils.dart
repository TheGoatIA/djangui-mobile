class VersionUtils {
  /// Compare deux versions sémantiques.
  /// Retourne :
  ///  - 1 si v1 > v2
  ///  - -1 si v1 < v2
  ///  - 0 si v1 == v2
  static int compare(String v1, String v2) {
    if (v1 == v2) return 0;

    final parts1 = v1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final parts2 = v2.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    // S'assurer d'avoir au moins 3 parties (major.minor.patch)
    while (parts1.length < 3) {
      parts1.add(0);
    }
    while (parts2.length < 3) {
      parts2.add(0);
    }

    for (var i = 0; i < 3; i++) {
      if (parts1[i] > parts2[i]) return 1;
      if (parts1[i] < parts2[i]) return -1;
    }

    return 0;
  }

  /// Vérifie si la version actuelle [current] est supérieure ou égale à la version minimale [min].
  static bool isAtLeast(String current, String min) {
    return compare(current, min) >= 0;
  }
}
