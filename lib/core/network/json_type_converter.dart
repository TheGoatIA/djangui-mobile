import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:logger/logger.dart';
import '../../di/injection.dart';
import 'models/base_response.dart';

class JsonToTypeConverter extends JsonConverter {
  final Map<Type, Function> typeDecoders;

  const JsonToTypeConverter(this.typeDecoders);

  @override
  FutureOr<Response<ResultType>> convertResponse<ResultType, Item>(
    Response response,
  ) async {
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
      return typeDecoders[T]!(json);
    }

    // Automatic handle for BaseResponse and BaseListResponse
    // This makes it scalable: you only need to register the Item type.
    final String typeString = T.toString();

    if (typeString.startsWith('BaseResponse')) {
      // Guard against Chopper's type inference if it passes BaseResponse as Item
      if (Item.toString().startsWith('BaseResponse') || Item == dynamic) {
        return _createBaseResponse<dynamic>(json);
      }
      return _createBaseResponse<Item>(json);
    }

    if (typeString.startsWith('BaseListResponse')) {
      if (Item.toString().startsWith('BaseResponse') || Item == dynamic) {
        return _createBaseListResponse<dynamic>(json);
      }
      return _createBaseListResponse<Item>(json);
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
        return data
                .map((e) => _decodeMap<I, dynamic>(e as Map<String, dynamic>))
                .toList()
            as I;
      }
      return data as I;
    });
  }

  BaseListResponse<I> _createBaseListResponse<I>(Map<String, dynamic> json) {
    return BaseListResponse<I>.fromJson(json, (data) {
      if (data is Map<String, dynamic>) {
        return _decodeMap<I, dynamic>(data) as I;
      }
      return data as I;
    });
  }
}
