abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([super.message = 'Erreur serveur']);
}

class NetworkFailure extends Failure {
  NetworkFailure([super.message = 'Pas de connexion internet']);
}

class CacheFailure extends Failure {
  CacheFailure([super.message = 'Erreur cache local']);
}

class AuthFailure extends Failure {
  AuthFailure(super.message);
}
