import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

class BaseResponse<T> {
  final bool success;
  final String? message;
  final T? data;

  BaseResponse({required this.success, this.message, this.data});

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    // Robust success check: handle both boolean 'success' and string 'status'
    final bool isSuccess =
        (json['success'] == true) ||
        (json['status'] == 'success') ||
        (json['status'] != 'error' && json['success'] == null);

    return BaseResponse<T>(
      success: isSuccess,
      message: json['message'] as String?,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) {
    final value = data;
    return {
      'success': success,
      'message': message,
      'data': value == null ? null : toJsonT(value),
    };
  }
}

class BaseListResponse<T> {
  final bool success;
  final String? message;
  final List<T>? data;
  final Pagination? pagination;

  BaseListResponse({
    required this.success,
    this.message,
    this.data,
    this.pagination,
  });

  factory BaseListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    // Robust success check: handle both boolean 'success' and string 'status'
    final bool isSuccess =
        (json['success'] == true) ||
        (json['status'] == 'success') ||
        (json['status'] != 'error' && json['success'] == null);

    return BaseListResponse<T>(
      success: isSuccess,
      message: json['message'] as String?,
      data:
          ((json['data'] ??
                      json['transactions'] ??
                      json['results'] ??
                      json['items'])
                  as List<dynamic>?)
              ?.map<T>(fromJsonT)
              .toList(),
      pagination: json['pagination'] == null
          ? null
          : Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => {
    'success': success,
    'message': message,
    'data': data?.map(toJsonT).toList(),
    'pagination': pagination?.toJson(),
  };
}

@JsonSerializable()
class Pagination {
  final int page;
  final int total;
  final int pages;

  Pagination({required this.page, required this.total, required this.pages});

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}
