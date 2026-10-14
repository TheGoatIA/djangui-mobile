import 'package:flutter_test/flutter_test.dart';
import 'package:kauri/core/error/error_mapper.dart';

/// Contrat de sécurité : aucun détail interne (trace, JSON brut, chemin, driver DB, exception
/// Dart) ne doit jamais atteindre l'utilisateur.
void main() {
  const leaks = [
    'node_modules',
    '.js:',
    '.ts:',
    'MongoServerError',
    'ECONNREFUSED',
    'SocketException',
    'FormatException',
    'Instance of',
    'Stack',
    '#0 ',
    '{"',
  ];

  final nasty = <String>[
    'MongoServerError: E11000 duplicate key error collection: kauri.users index: email_1',
    'Error: connect ECONNREFUSED 127.0.0.1:27017\n    at TCPConnectWrap.afterConnect (node:net:1555:16)',
    '{"status":"error","message":"Cast to ObjectId failed","stack":"Error at /app/dist/x.js:1:1"}',
    "FormatException: Unexpected character (at character 1)\n<html>",
    'Exception: Instance of \'_Exception\'\n#0      main (file:///C:/app/main.dart:10:3)',
    'SocketException: Failed host lookup: api.kauri-app.com (OS Error: No address associated with hostname)',
  ];

  for (final raw in nasty) {
    test('nettoie : ${raw.split('\n').first}', () {
      final msg = ErrorMapper.safeMessage(Exception(raw));
      expect(msg, isNotEmpty);
      for (final marker in leaks) {
        expect(
          msg.contains(marker),
          isFalse,
          reason: 'le message exposé contient "$marker" : $msg',
        );
      }
    });
  }

  test('retombe sur un message par code HTTP quand rien d’exploitable', () {
    expect(ErrorMapper.safeMessage(null, statusCode: 401), contains('session'));
    expect(
      ErrorMapper.safeMessage(null, statusCode: 429),
      contains('tentatives'),
    );
    expect(
      ErrorMapper.safeMessage(null, statusCode: 503),
      contains('indisponibilité'),
    );
  });

  test('un message backend lisible est conservé', () {
    final msg = ErrorMapper.safeMessage(
      null,
      backendMessage: 'Mot de passe incorrect',
      statusCode: 401,
    );
    expect(msg, contains('Mot de passe incorrect'));
  });
}
