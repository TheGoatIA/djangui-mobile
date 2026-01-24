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
    if (body == null) return null;

    // Si le corps est une liste, on décode chaque élément vers le type 'Item'
    if (body is List) {
      return body
              .map<Item>(
                (e) => _decodeMap<Item, dynamic>(e as Map<String, dynamic>),
              )
              .toList()
          as ResultType;
    }

    if (body is Map<String, dynamic>) {
      return _decodeMap<ResultType, Item>(body);
    }

    return body;
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
