/// Validateur centralisé pour la complexité des mots de passe (F28).
///
/// Exigences :
/// - Au moins 8 caractères
/// - Au moins 1 lettre majuscule ([A-Z])
/// - Au moins 1 lettre minuscule ([a-z])
/// - Au moins 1 chiffre ([0-9])
/// - Au moins 1 caractère spécial ([!@#\$%^&*(),.?":{}|<>_\-+=[\]\\/`~;])
class PasswordValidator {
  static final RegExp _hasUppercase = RegExp(r'[A-Z]');
  static final RegExp _hasLowercase = RegExp(r'[a-z]');
  static final RegExp _hasDigit = RegExp(r'[0-9]');
  static final RegExp _hasSpecial = RegExp(
    r'[!@#\$%^&*(),.?":{}|<>_\-+=[\]\\/`~;]',
  );

  /// Vérifie si le mot de passe satisfait tous les critères de complexité.
  static bool isValid(String? password) {
    if (password == null || password.length < 8) return false;
    if (!_hasUppercase.hasMatch(password)) return false;
    if (!_hasLowercase.hasMatch(password)) return false;
    if (!_hasDigit.hasMatch(password)) return false;
    if (!_hasSpecial.hasMatch(password)) return false;
    return true;
  }

  /// Retourne un message d'erreur approprié ou null si valide.
  static String? validate(
    String? password, {
    required String emptyError,
    required String complexityError,
  }) {
    if (password == null || password.trim().isEmpty) {
      return emptyError;
    }
    if (!isValid(password)) {
      return complexityError;
    }
    return null;
  }
}
