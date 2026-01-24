import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:injectable/injectable.dart';

/// Interface définissant le service de vérification de l'état de la connexion internet.
abstract class NetworkInfo {
  /// Retourne [true] si l'appareil dispose d'un accès à internet.
  Future<bool> get isConnected;
}

/// Implémentation du service NetworkInfo utilisant 'internet_connection_checker'.
@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker _connectionChecker;

  NetworkInfoImpl(this._connectionChecker);

  @override
  Future<bool> get isConnected => _connectionChecker.hasConnection;
}
