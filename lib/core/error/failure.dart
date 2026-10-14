import 'package:equatable/equatable.dart';

/// Version enrichie de gestion des erreurs utilisant [Equatable] pour faciliter
/// la comparaison d'états dans les Blocs.
///
/// Note : Cette classe inclut un [code] d'erreur optionnel pour un traitement programmatique.
abstract class Failure extends Equatable {
  /// Description de l'erreur.
  final String message;

  /// Code d'erreur technique (ex: '404', 'AUTH_REQUIRED').
  final String? code;

  const Failure([this.message = 'Erreur inattendue', this.code]);

  @override
  List<Object?> get props => [message, code];
}

/// Échec lors d'une requête API serveur.
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Erreur serveur', super.code]);
}

/// Échec lié au stockage local (base de données, SharedPreferences).
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Erreur de cache local', super.code]);
}

/// Échec lié à la couche réseau (timeout, pas d'internet).
class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Erreur de connexion réseau',
    super.code,
  ]);
}

/// Échec de validation de données (formulaires, contraintes métier).
class ValidationFailure extends Failure {
  const ValidationFailure([
    super.message = 'Erreur de validation des données',
    super.code,
  ]);
}

/// Échec spécifique aux processus d'authentification (jeton invalide, accès refusé).
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Erreur d\'authentification', super.code]);
}
