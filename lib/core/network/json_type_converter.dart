import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:logger/logger.dart';
import '../../di/injection.dart';
import 'models/base_response.dart';

/// Convertisseur JSON personnalisé pour Chopper permettant le mapping automatique vers des types typés.
///
/// Ce convertisseur utilise un dictionnaire de décodeurs ([typeDecoders]) pour transformer
/// les réponses JSON brutes en objets métiers ou en structures de type [BaseResponse].
class JsonToTypeConverter extends JsonConverter {
  /// Map associant un type de classe à sa fonction de décodage (ex: (json) => User.fromJson(json)).
  final Map<Type, Function> typeDecoders;

  const JsonToTypeConverter(this.typeDecoders);

  @override
  Request convertRequest(Request request) {
    if (request.multipart) {
      return request;
    }
    return super.convertRequest(request);
  }

  @override
  FutureOr<Response<ResultType>> convertResponse<ResultType, Item>(
    Response response,
  ) async {
    // Vérifie si le corps est vide avant de tenter un décodage JSON
    final dynamic rawBody = response.body;
    if (rawBody == null ||
        (rawBody is String && rawBody.trim().isEmpty) ||
        (rawBody is List && rawBody.isEmpty)) {
      return Response<ResultType>(response.base, null, error: response.error);
    }

    // Utilise le convertisseur JSON de base de Chopper pour décoder la chaîne en Map/List
    final Response<dynamic> jsonRes = await super
        .convertResponse<dynamic, dynamic>(response);
    final dynamic body = jsonRes.body;

    try {
      // Tente de mapper le corps décodé vers le type de résultat attendu (ResultType)
      return jsonRes.copyWith<ResultType>(
        body: _decode<ResultType, Item>(body),
      );
    } catch (e) {
      getIt<Logger>().e(
        '❌ [JsonToTypeConverter] Erreur de décodage pour $ResultType: $e\nCorps: $body',
      );
      rethrow;
    }
  }

  @override
  FutureOr<Response> convertError<ResultType, Item>(Response response) async {
    final dynamic rawBody = response.body;
    if (rawBody == null ||
        (rawBody is String && rawBody.trim().isEmpty) ||
        (rawBody is List && rawBody.isEmpty)) {
      return response;
    }

    final Response<dynamic> jsonRes = await super
        .convertError<dynamic, dynamic>(response);
    final dynamic body = jsonRes.body;

    try {
      return jsonRes.copyWith(body: _decode<dynamic, dynamic>(body));
    } catch (e) {
      getIt<Logger>().e(
        '❌ [JsonToTypeConverter] Erreur de décodage d\'erreur : $e\nCorps: $body',
      );
      return jsonRes;
    }
  }

  /// Méthode récursive pour décoder une structure (List ou Map) vers un type typé.
  dynamic _decode<ResultType, Item>(dynamic body) {
    // 🛠️ SANITIZATION: Fix raw Mongoose documents and Buffer IDs
    final sanitizedBody = _sanitizeResponse(body);

    if (sanitizedBody == null) return null;

    // Si le corps est une liste, on décode chaque élément vers le type 'Item'
    if (sanitizedBody is List) {
      return sanitizedBody
              .map<Item>(
                (e) => _decodeMap<Item, dynamic>(e as Map<String, dynamic>),
              )
              .toList()
          as ResultType;
    }

    if (sanitizedBody is Map<String, dynamic>) {
      return _decodeMap<ResultType, Item>(sanitizedBody);
    }

    return sanitizedBody;
  }

  /// Nettoie la réponse JSON pour gérer les documents Mongoose bruts et les Buffers
  dynamic _sanitizeResponse(dynamic data) {
    if (data is List) {
      return data.map((e) => _sanitizeResponse(e)).toList();
    }
    if (data is Map<String, dynamic>) {
      Map<String, dynamic> map = data;
      // 1. Flatten Mongoose _doc if present (backend returns raw doc)
      if (map.containsKey('_doc') && map['_doc'] is Map) {
        map = Map<String, dynamic>.from(map['_doc']);
      }

      final Map<String, dynamic> newMap = {};
      map.forEach((key, value) {
        // 2. Fix Buffer objects for IDs (e.g. _id: { buffer: {0: 105...} })
        if ((key == '_id' || key.endsWith('Id')) &&
            value is Map &&
            value.containsKey('buffer')) {
          try {
            final buffer = value['buffer'];
            if (buffer is Map) {
              final sortedKeys =
                  buffer.keys.map((k) => int.parse(k.toString())).toList()
                    ..sort();
              final List<int> bytes = sortedKeys
                  .map((k) => buffer[k.toString()] as int)
                  .toList();
              // Convert bytes to Hex String
              newMap[key] = bytes
                  .map((b) => b.toRadixString(16).padLeft(2, '0'))
                  .join();
            } else {
              newMap[key] = _sanitizeResponse(value);
            }
          } catch (e) {
            newMap[key] = value;
          }
        } else {
          newMap[key] = _sanitizeResponse(value);
        }
      });
      return newMap;
    }
    return data;
  }

  /// Décode une Map unique vers le type cible [T].
  /// Gère les types génériques comme [BaseResponse] et [BaseListResponse].
  dynamic _decodeMap<T, Item>(Map<String, dynamic> json) {
    if (T == dynamic ||
        T == Object ||
        T == Map ||
        T == (Map<String, dynamic>)) {
      return json;
    }

    // Utilisation du décodeur enregistré dans typeDecoders
    if (typeDecoders.containsKey(T)) {
      return typeDecoders[T]!(json);
    }

    // Comparaison flexible par nom de type pour éviter les soucis de Type instances
    for (final key in typeDecoders.keys) {
      if (key.toString() == T.toString()) {
        return typeDecoders[key]!(json);
      }
    }

    // Gestion automatique des réponses standardisées de l'API (BaseResponse & BaseListResponse)
    final String typeString = T.toString();

    if (typeString.startsWith('BaseListResponse')) {
      if (Item.toString() != 'dynamic' &&
          !Item.toString().startsWith('BaseResponse')) {
        return _createBaseListResponse<Item>(json);
      }
      return _createBaseListResponse<dynamic>(json);
    }

    if (typeString.startsWith('BaseResponse')) {
      if (Item.toString() != 'dynamic' &&
          !Item.toString().startsWith('BaseResponse')) {
        return _createBaseResponse<Item>(json);
      }
      return _createBaseResponse<dynamic>(json);
    }

    getIt<Logger>().w(
      '⚠️ [JsonToTypeConverter] Aucun décodeur trouvé pour le type: $T (Item: $Item)',
    );
    return json;
  }

  /// Instancie une [BaseResponse] avec le type de données interne [I].
  BaseResponse<I> _createBaseResponse<I>(Map<String, dynamic> json) {
    return BaseResponse<I>.fromJson(json, (data) {
      if (data is Map<String, dynamic>) {
        return _decodeMap<I, dynamic>(data) as I;
      }
      if (data is List) {
        final List<dynamic> decodedList = data.map((e) {
          if (e is Map<String, dynamic>) {
            return e;
          }
          return e;
        }).toList();

        try {
          return decodedList as I;
        } catch (_) {
          return decodedList as dynamic;
        }
      }
      return data as I;
    });
  }

  /// Instancie une [BaseListResponse] avec le type d'élément interne [I].
  BaseListResponse<I> _createBaseListResponse<I>(Map<String, dynamic> json) {
    return BaseListResponse<I>.fromJson(json, (data) {
      if (data is Map<String, dynamic>) {
        return _decodeMap<I, dynamic>(data) as I;
      }
      return data as I;
    });
  }
}
