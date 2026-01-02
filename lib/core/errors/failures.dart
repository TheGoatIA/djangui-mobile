abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([String message = 'Erreur serveur']) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure([String message = 'Pas de connexion internet'])
    : super(message);
}

class CacheFailure extends Failure {
  CacheFailure([String message = 'Erreur cache local']) : super(message);
}

class AuthFailure extends Failure {
  AuthFailure(String message) : super(message);
}
