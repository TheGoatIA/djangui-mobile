import 'package:biometric_storage/biometric_storage.dart';
import 'package:injectable/injectable.dart';

/// Stockage protégé par une clé Keystore (Android) / Keychain (iOS) qui
/// EXIGE elle-même une authentification biométrique matérielle pour être
/// déchiffrée (audit F-01/F-02).
///
/// Contrairement à `local_auth` seul — qui ne renvoie qu'un booléen que le
/// code appelant est libre d'ignorer, ou qu'un hook Frida sur un appareil
/// rooté peut faire renvoyer `true` sans jamais présenter de biométrie
/// réelle — la vérification biométrique se produit ICI, au niveau du
/// matériel sécurisé (TEE/Secure Enclave), au moment même du déchiffrement.
/// Hooker `authenticate()` en Dart ne donne alors accès à rien : la clé
/// reste verrouillée tant que le matériel n'a pas vu une biométrie valide.
@lazySingleton
class BiometricGatedStorage {
  static const _fileName = 'biometric_token';
  BiometricStorageFile? _file;

  Future<BiometricStorageFile> _storage() async {
    return _file ??= await BiometricStorage().getStorage(_fileName);
  }

  /// À vérifier avant de proposer l'option "Activer la biométrie" dans l'UI —
  /// un appareil sans capteur biométrique enrôlé ne doit pas afficher un
  /// bouton qui échouera systématiquement.
  Future<bool> isSupported() async {
    final response = await BiometricStorage().canAuthenticate();
    return response == CanAuthenticateResponse.success;
  }

  Future<void> write(String token) async {
    final storage = await _storage();
    await storage.write(token);
  }

  /// Déclenche l'invite biométrique native. Retourne `null` si l'utilisateur
  /// annule/échoue la vérification, ou si rien n'a jamais été écrit.
  Future<String?> read() async {
    final storage = await _storage();
    try {
      return await storage.read();
    } on AuthException {
      return null;
    }
  }

  Future<void> delete() async {
    final storage = await _storage();
    await storage.delete();
  }
}
