import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:injectable/injectable.dart';

/// Interface définissant le service de vérification de l'état de la connexion internet.
abstract class NetworkInfo {
  /// Retourne [true] si l'appareil dispose d'un accès à internet.
  Future<bool> get isConnected;

  /// Flux réactif de l'état de connexion, pour les widgets qui doivent
  /// signaler à l'utilisateur qu'un écran affiche des données en cache
  /// (voir [CachedDataBanner]) sans avoir à replumber ce signal à travers
  /// chaque couche repository/bloc.
  Stream<bool> get onConnectivityChanged;
}

/// Implémentation du service NetworkInfo utilisant 'internet_connection_checker'.
@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker _connectionChecker;

  NetworkInfoImpl(this._connectionChecker);

  @override
  Future<bool> get isConnected => _connectionChecker.hasConnection;

  @override
  Stream<bool> get onConnectivityChanged => _connectionChecker.onStatusChange
      .map((status) => status == InternetConnectionStatus.connected);
}
