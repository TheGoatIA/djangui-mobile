import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'package:kauri/core/error/error_mapper.dart';

/// Extension sur la classe [Response] de Chopper pour extraire un message
/// d'erreur toujours propre, sécurisé et prêt à être affiché à l'utilisateur.
extension ResponseExtension on Response {
  /// Extrait un message d'erreur clair et sécurisé à partir de la réponse HTTP.
  String get errorMessage {
    String? candidate;

    // 1. Analyse de la propriété error (remplie par Chopper en cas d'erreur HTTP)
    candidate ??= _extractMessageFrom(error);

    // 2. Analyse du corps (body)
    candidate ??= _extractMessageFrom(body);

    // 3. Passe le candidat ou le statut HTTP à ErrorMapper pour assainissement complet
    return ErrorMapper.safeMessage(
      error,
      backendMessage: candidate,
      statusCode: statusCode,
    );
  }

  /// Tente d'extraire la phrase descriptive d'une structure Map, List ou JSON stringifié.
  static String? _extractMessageFrom(dynamic data) {
    if (data == null) return null;

    // Si data est une chaîne JSON
    if (data is String) {
      final trimmed = data.trim();
      if ((trimmed.startsWith('{') && trimmed.endsWith('}')) ||
          (trimmed.startsWith('[') && trimmed.endsWith(']'))) {
        try {
          final decoded = jsonDecode(trimmed);
          return _extractMessageFrom(decoded);
        } catch (_) {}
      }
      return data;
    }

    // Si data est une Map (JSON parsé)
    if (data is Map) {
      // Clé 'message'
      if (data.containsKey('message')) {
        final msg = data['message'];
        if (msg is String && msg.isNotEmpty) return msg;
        if (msg is List && msg.isNotEmpty) {
          return msg.map((e) => e.toString()).join(' ');
        }
      }

      // Clé 'error'
      if (data.containsKey('error')) {
        final err = data['error'];
        if (err is String && err.isNotEmpty) return err;
        if (err is Map) return _extractMessageFrom(err);
      }

      // Clé 'errors' (validation formulaires)
      if (data.containsKey('errors')) {
        final errs = data['errors'];
        if (errs is List && errs.isNotEmpty) {
          return errs.map((e) => e.toString()).join(' ');
        }
        if (errs is Map && errs.isNotEmpty) {
          return errs.values.map((e) => e.toString()).join(' ');
        }
      }

      // Clé 'detail' ou 'description'
      if (data.containsKey('detail') && data['detail'] is String) {
        return data['detail'] as String;
      }
      if (data.containsKey('description') && data['description'] is String) {
        return data['description'] as String;
      }
    }

    return null;
  }
}
