import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/auth_response.dart';
import '../../data/models/user_model.dart';
import '../../data/models/login_request.dart';
import '../../data/models/register_request.dart';
import '../../data/models/session_model.dart';
import '../../data/models/country_change_request.dart';

/// Interface définissant le contrat pour la gestion de l'authentification et du profil utilisateur.
///
/// Cette couche de domaine fait abstraction de la provenance des données (Firebase, API REST, Cache local).
abstract class AuthRepository {
  /// Connecte un utilisateur via email et mot de passe.
  Future<Either<Failure, AuthResponse>> login(LoginRequest request);

  /// Authentifie l'utilisateur via Google. Optionnellement, définit son pays par défaut.
  Future<Either<Failure, AuthResponse>> signInWithGoogle({String? countryCode});

  /// Authentifie l'utilisateur via Apple. Optionnellement, définit son pays par défaut.
  Future<Either<Failure, AuthResponse>> signInWithApple({String? countryCode});

  /// Démarre le processus de vérification de numéro de téléphone (Envoi de SMS).
  Future<Either<Failure, void>> verifyPhoneNumber(
    String phoneNumber, {
    required Function(String verificationId) onCodeSent,
    required Function(String errorMessage) onVerificationFailed,
  });

  /// Finalise la connexion par téléphone après réception du code SMS.
  Future<Either<Failure, AuthResponse>> signInWithPhoneNumber(
    String verificationId,
    String smsCode, {
    String? country,
  });

  /// Lie un numéro de téléphone à un compte existant.
  Future<Either<Failure, void>> linkPhoneNumber(
    String verificationId,
    String smsCode,
  );

  /// Enregistre un nouvel utilisateur (Inscription standard).
  Future<Either<Failure, AuthResponse>> register(RegisterRequest request);

  /// Déconnecte l'utilisateur et nettoie les sessions locales.
  Future<Either<Failure, void>> logout();

  /// Vérifie si une session valide existe localement.
  Future<bool> isAuthenticated();

  /// Récupère le jeton d'accès actuel.
  Future<String?> getAccessToken();

  /// Récupère le jeton de rafraîchissement actuel.
  Future<String?> getRefreshToken();

  /// Récupère les informations de l'utilisateur connecté depuis le serveur ou le cache.
  Future<Either<Failure, UserModel>> getCurrentUser();

  /// Met à jour les informations du profil utilisateur.
  Future<Either<Failure, UserModel>> updateProfile({
    String? firstName,
    String? lastName,
    String? country,
    String? avatar,
    double? monthlyIncome,
    UserPreferences? preferences,
  });

  /// Met à jour la préférence linguistique de l'utilisateur sur le serveur.
  Future<Either<Failure, void>> updateLanguage(String languageCode);

  /// Demande une réinitialisation de mot de passe par email.
  Future<Either<Failure, void>> forgotPassword(String email);

  /// Réinitialise le mot de passe à l'aide d'un jeton reçu par email.
  Future<Either<Failure, void>> resetPassword(String token, String newPassword);

  /// Vérifie l'adresse email de l'utilisateur.
  Future<Either<Failure, void>> verifyEmail(String token);

  /// Rafraîchit les jetons d'authentification arrivés à expiration.
  Future<Either<Failure, void>> refreshToken([String? token]);

  /// Met à jour le jeton Firebase Cloud Messaging pour les notifications.
  Future<Either<Failure, void>> updateFcmToken(String token);

  /// Met à jour les informations techniques sur l'appareil de l'utilisateur.
  Future<void> updateDeviceInfo();

  /// Modifie le mot de passe de l'utilisateur.
  Future<Either<Failure, void>> changePassword(
    String currentPassword,
    String newPassword,
  );

  /// Supprime définitivement le compte utilisateur.
  Future<Either<Failure, void>> deleteAccount();

  /// Liste toutes les sessions actives pour cet utilisateur.
  Future<Either<Failure, List<SessionModel>>> getSessions();

  /// Révoque une session spécifique par son identifiant.
  Future<Either<Failure, void>> revokeSession(String sessionId);

  /// Révoque toutes les autres sessions actives à part l'actuelle.
  Future<Either<Failure, void>> revokeAllOtherSessions();

  /// Enregistre une trace de connexion (IP, localisation, appareil).
  Future<void> logConnection();

  /// Demande un changement de pays de résidence (peut nécessiter une validation).
  Future<Either<Failure, CountryChangeRequestModel>> requestCountryChange(
    String countryCode,
  );

  /// Retourne le fournisseur d'accès utilisé (google, password, etc.).
  Future<String?> getLoginProvider();

  /// Sauvegarde le fournisseur d'accès utilisé.
  Future<void> saveLoginProvider(String provider);

  /// Récupère le jeton spécifique à l'authentification biométrique.
  Future<String?> getBiometricToken();

  /// Sauvegarde le jeton spécifique à l'authentification biométrique.
  Future<void> saveBiometricToken(String token);

  /// Révoque le jeton biométrique (ex: désactivation dans les réglages) —
  /// sans ça, un jeton déjà déchiffrable resterait utilisable même après que
  /// l'utilisateur pense avoir coupé l'accès rapide (audit F-02).
  Future<void> clearBiometricToken();

  /// Soumet les documents KYC pour validation.
  Future<Either<Failure, Map<String, dynamic>>> submitKYC({
    required String documentType,
    required String documentNumber,
    required String fullName,
    String? documentExpiryDate,
    required String documentImageUrl,
    String? documentBackImageUrl,
    required String selfieImageUrl,
  });
}
