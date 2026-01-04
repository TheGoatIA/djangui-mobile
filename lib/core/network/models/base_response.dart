import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> {
  final bool success;
  final String? message;
  final T? data;

  BaseResponse({required this.success, this.message, this.data});

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$BaseResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BaseResponseToJson(this, toJsonT);
}

@JsonSerializable(genericArgumentFactories: true)
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
  ) => _$BaseListResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BaseListResponseToJson(this, toJsonT);
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
