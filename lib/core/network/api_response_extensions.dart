import 'package:chopper/chopper.dart';

/// Extension pratique sur la classe [Response] de Chopper pour simplifier le traitement des erreurs.
extension ResponseExtension on Response {
  /// Extrait un message d'erreur lisible à partir du corps de la réponse.
  ///
  /// Analyse les structures de données [Map] retournées par le serveur pour trouver
  /// une clé 'message'. Si rien n'est trouvé, retourne un message générique avec le code HTTP.
  String get errorMessage {
    // 1. Analyse du corps (body) pour les réponses encapsulées
    final dynamic bodyData = body;
    if (bodyData is Map && bodyData.containsKey('message')) {
      final message = bodyData['message'];
      if (message != null && message.toString().isNotEmpty) {
        return message.toString();
      }
    }

    // 2. Analyse de la propriété error (remplie par Chopper en cas d'échec isSuccessful)
    final dynamic errorData = error;
    if (errorData is Map && errorData.containsKey('message')) {
      final message = errorData['message'];
      if (message != null && message.toString().isNotEmpty) {
        return message.toString();
      }
    }

    // 3. Fallback sur le contenu brut de l'erreur
    if (error != null) {
      final errorStr = error.toString();
      if (errorStr.isNotEmpty && errorStr != 'null') {
        return errorStr;
      }
    }

    return 'Une erreur inconnue est survenue (Code: $statusCode)';
  }
}
