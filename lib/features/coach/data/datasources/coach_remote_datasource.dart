import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'coach_api_service.dart';
import '../models/chat_message_model.dart';
import '../models/coach_stream_event.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/network/api_response_extensions.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

abstract class CoachRemoteDataSource {
  Stream<CoachStreamEvent> sendMessageStream(String text);
  Future<List<ChatMessageModel>> getChatHistory();
}

// Routé via un http.Client brut plutôt que Chopper (CoachApiService) : les
// méthodes générées par Chopper attendent une réponse complète avant de la
// convertir, incompatible avec une lecture progressive du corps au fil de
// l'eau. Seul l'appel de streaming bypass Chopper ; l'historique continue de
// passer par CoachApiService comme avant.
@LazySingleton(as: CoachRemoteDataSource)
class CoachRemoteDataSourceImpl implements CoachRemoteDataSource {
  final CoachApiService _apiService;
  final AuthRepository _authRepository;

  CoachRemoteDataSourceImpl(this._apiService, this._authRepository);

  @override
  Stream<CoachStreamEvent> sendMessageStream(String text) async* {
    final client = http.Client();
    try {
      final response = await _sendStreamRequest(client, text);
      if (response == null) {
        yield const CoachStreamFailure(
          'Session expirée. Veuillez vous reconnecter.',
        );
        return;
      }

      if (response.statusCode != 200) {
        final body = await response.stream.bytesToString();
        yield CoachStreamFailure(
          _extractErrorMessage(body, response.statusCode),
        );
        return;
      }

      final lines = response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      try {
        await for (final line in lines) {
          if (line.trim().isEmpty) continue;
          Map<String, dynamic> event;
          try {
            event = jsonDecode(line) as Map<String, dynamic>;
          } catch (_) {
            continue; // ligne corrompue/partielle : ignorée plutôt que de casser tout le flux
          }

          if (event['delta'] != null) {
            yield CoachStreamDelta(event['delta'] as String);
          } else if (event['done'] == true) {
            yield CoachStreamDone(
              event['actions'] as List<dynamic>? ?? const [],
            );
          } else if (event['error'] != null) {
            yield CoachStreamFailure(event['error'] as String);
          }
        }
      } catch (e) {
        debugPrint('🌐 [CoachRemote] Stream interrompu: $e');
        yield CoachStreamFailure(
          'La connexion avec Anne a été interrompue. Réessayez.',
        );
      }
    } finally {
      client.close();
    }
  }

  /// Envoie la requête de streaming ; en cas de 401, tente UN rafraîchissement
  /// de token puis un seul nouvel essai (mêmes principes que
  /// KauriAuthenticator, en plus simple : un seul appel en vol ici, pas
  /// besoin de mutex inter-requêtes). Réutilise le même [client] (fermé par
  /// l'appelant) pour que la deuxième tentative passe par la même connexion.
  Future<http.StreamedResponse?> _sendStreamRequest(
    http.Client client,
    String text, {
    bool isRetry = false,
  }) async {
    final token = await _authRepository.getAccessToken();
    final uri = Uri.parse('${EnvConfig.apiBaseUrl}/coach/ask/stream');
    final request = http.Request('POST', uri)
      ..headers['Content-Type'] = 'application/json'
      ..headers['Accept'] = 'application/x-ndjson'
      ..body = jsonEncode({'message': text});
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final response = await client.send(request);

    if (response.statusCode == 401 && !isRetry) {
      await response.stream.drain<void>().catchError((_) {});
      final refreshResult = await _authRepository.refreshToken();
      final refreshed = refreshResult.fold((_) => false, (_) => true);
      if (!refreshed) return null;
      return _sendStreamRequest(client, text, isRetry: true);
    }

    return response;
  }

  String _extractErrorMessage(String body, int statusCode) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['message'] is String) {
        return decoded['message'] as String;
      }
    } catch (_) {
      // corps non-JSON : message générique ci-dessous
    }
    return 'Erreur serveur ($statusCode)';
  }

  @override
  Future<List<ChatMessageModel>> getChatHistory() async {
    debugPrint('🌐 [CoachRemote] Fetching chat history...');
    final response = await _apiService.getChatHistory();
    if (response.isSuccessful && response.body != null) {
      final dynamic body = response.body;
      List<dynamic> messageList = [];

      if (body is Map &&
          body['data'] != null &&
          body['data']['messages'] != null) {
        messageList = body['data']['messages'] as List<dynamic>;
      }

      final history = messageList.map((m) {
        final map = m as Map<String, dynamic>;
        return ChatMessageModel(
          id: map['_id'] ?? DateTime.now().microsecondsSinceEpoch.toString(),
          text: map['content'] ?? '',
          sender: map['role'] == 'model' ? 'ai' : (map['role'] ?? 'user'),
          timestamp: map['timestamp'] != null
              ? DateTime.parse(map['timestamp'])
              : DateTime.now(),
          actions: map['actions'],
        );
      }).toList();

      debugPrint(
        '🌐 [CoachRemote] Success: Received ${history.length} messages',
      );
      return history;
    } else {
      debugPrint('🌐 [CoachRemote] Error: ${response.errorMessage}');
      throw Exception(response.errorMessage);
    }
  }
}
