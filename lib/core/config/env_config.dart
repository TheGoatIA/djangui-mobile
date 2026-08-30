/// Configuration de l'environnement via dart-define.
///
/// Les valeurs sont injectees a la compilation via:
///   flutter build apk --dart-define-from-file=dart_defines.dev.json
///
/// Ne jamais mettre de secrets dans ces variables - utiliser uniquement
/// pour les URLs et configurations non-sensibles.
class EnvConfig {
  EnvConfig._();

  /// URL de base de l'API Kauri.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5000/api/v1',
  );

  /// Endpoint OTEL pour la telemetrie.
  static const String otelEndpoint = String.fromEnvironment(
    'OTEL_ENDPOINT',
    defaultValue: '',
  );

  /// Endpoint distant pour l'envoi des logs applicatifs (Graylog/ELK).
  /// Vide par defaut: le logging distant est desactive tant qu'aucune
  /// valeur n'est fournie via --dart-define-from-file.
  static const String apiLogsEndpoint = String.fromEnvironment(
    'API_LOGS_ENDPOINT',
    defaultValue: '',
  );

  /// Clé identifiant un client mobile officiel auprès de l'endpoint public
  /// de télémétrie (`/system/telemetry/:type`, non authentifié par JWT pour
  /// que la télémétrie pré-connexion fonctionne — voir K-07). Pas un vrai
  /// secret (embarqué dans l'app comme une clé API Firebase) : sert juste à
  /// écarter le spam anonyme sur cet endpoint, pas à protéger des données.
  static const String logsClientKey = String.fromEnvironment(
    'LOGS_CLIENT_KEY',
    defaultValue: '',
  );

  /// Nom du service OTEL.
  static const String otelServiceName = String.fromEnvironment(
    'OTEL_SERVICE_NAME',
    defaultValue: 'kauri-mobile',
  );

  /// Environnement courant (development, staging, production).
  /// Active ou desactive le mode argent reel (sinon mode simulation virtuelle).
  /// Par defaut: false (mode virtuel securise / simulation active).
  static const bool enableRealMoney = bool.fromEnvironment(
    'ENABLE_REAL_MONEY',
    defaultValue: false,
  );

  static const String env = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  static bool get isProduction => env == 'production';
  static bool get isDevelopment => env == 'development';
  static bool get isStaging => env == 'staging';
}
