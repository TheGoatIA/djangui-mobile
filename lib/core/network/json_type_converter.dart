import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:logger/logger.dart';
import '../../di/injection.dart';
import 'models/base_response.dart';

class JsonToTypeConverter extends JsonConverter {
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
    // Check if body is empty before letting Chopper try to decode it as JSON
    // We check the raw response body. If it's empty, we return null immediately.
    final dynamic rawBody = response.body;
    if (rawBody == null ||
        (rawBody is String && rawBody.trim().isEmpty) ||
        (rawBody is List && rawBody.isEmpty)) {
      return Response<ResultType>(response.base, null, error: response.error);
    }

    // Use Chopper's JsonConverter to decode the string to Map/List
    // We must pass dynamic because super.convertResponse attempts to cast it
    final Response<dynamic> jsonRes = await super
        .convertResponse<dynamic, dynamic>(response);
    final dynamic body = jsonRes.body;

    try {
      return jsonRes.copyWith<ResultType>(
        body: _decode<ResultType, Item>(body),
      );
    } catch (e) {
      getIt<Logger>().e(
        '❌ [JsonToTypeConverter] Error decoding $ResultType: $e\nBody: $body',
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
        '❌ [JsonToTypeConverter] Error decoding Error: $e\nBody: $body',
      );
      return jsonRes;
    }
  }

  dynamic _decode<ResultType, Item>(dynamic body) {
    if (body == null) return null;

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

  dynamic _decodeMap<T, Item>(Map<String, dynamic> json) {
    if (T == dynamic ||
        T == Object ||
        T == Map ||
        T == (Map<String, dynamic>)) {
      return json;
    }

    if (typeDecoders.containsKey(T)) {
      if (T.toString().contains('SupportTicketModel')) {
        getIt<Logger>().d(
          '[JsonToTypeConverter] Decoding SupportTicketModel. Keys: ${json.keys.toList()}',
        );
        // Check for null values in expected fields
        for (final key in [
          '_id',
          'subject',
          'message',
          'status',
          'category',
          'createdAt',
        ]) {
          if (json[key] == null) {
            getIt<Logger>().w(
              '[JsonToTypeConverter] Missing or Null field: $key',
            );
          }
        }
      }
      return typeDecoders[T]!(json);
    }

    // Try a more flexible check if T is a class (for different Type instances)
    for (final key in typeDecoders.keys) {
      if (key.toString() == T.toString()) {
        return typeDecoders[key]!(json);
      }
    }

    // Automatic handle for BaseResponse and BaseListResponse
    // This makes it scalable: you only need to register the Item type.
    final String typeString = T.toString();

    // Log for debugging
    getIt<Logger>().d(
      '[JsonToTypeConverter] Decoding type: $T (Item: $Item, String: $typeString)',
    );

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
        // Fallback: if we see a list but Item is not a list, it might be BaseResponse<List<Item>>
        // This is where the old cast error happened.
        return _createBaseResponse<Item>(json);
      }
      return _createBaseResponse<dynamic>(json);
    }

    getIt<Logger>().w(
      '⚠️ [JsonToTypeConverter] No decoder found for type: $T (Item: $Item)',
    );
    return json;
  }

  // To check types in the map that might be generic
  // We rely on exact Type match for now.

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

        // If I is exactly List<SupportTicketModel>, casting List<dynamic> will fail in Dart.
        // We can try to cast it if it matches the expected type I.
        try {
          return decodedList as I;
        } catch (_) {
          // If cast fails, we return the dynamic list and hope for the best or it will fail upstream
          return decodedList as dynamic;
        }
      }
      return data as I;
    });
  }

  BaseListResponse<I> _createBaseListResponse<I>(Map<String, dynamic> json) {
    return BaseListResponse<I>.fromJson(json, (data) {
      if (data is Map<String, dynamic>) {
        // We use I which is the Item type passed by DjanguiListResponse
        return _decodeMap<I, dynamic>(data) as I;
      }
      return data as I;
    });
  }
}
