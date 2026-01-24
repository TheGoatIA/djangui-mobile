/// Définition de base pour la gestion des erreurs (Failures) dans l'application.
/// Les "Failures" sont utilisées pour transformer les exceptions techniques en objets
/// compréhensibles par la couche métier (Domain) et l'interface utilisateur.
abstract class Failure {
  /// Message d'erreur lisible par l'utilisateur ou le développeur.
  final String message;
  Failure(this.message);
}

/// Erreur survenant lors d'un appel au serveur distant.
class ServerFailure extends Failure {
  ServerFailure([super.message = 'Erreur serveur']);
}

/// Erreur liée à l'absence de connectivité internet.
class NetworkFailure extends Failure {
  NetworkFailure([super.message = 'Pas de connexion internet']);
}

/// Erreur lors de l'accès ou de la manipulation des données en cache local.
class CacheFailure extends Failure {
  CacheFailure([super.message = 'Erreur cache local']);
}

/// Erreur spécifique aux processus d'authentification (jeton invalide, accès refusé).
class AuthFailure extends Failure {
  AuthFailure(super.message);
}
