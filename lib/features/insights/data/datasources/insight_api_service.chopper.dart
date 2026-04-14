// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'insight_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$InsightApiService extends InsightApiService {
  _$InsightApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = InsightApiService;

  @override
  Future<Response<dynamic>> getSpendingAnalysis({int? month, int? year}) {
    final Uri $url = Uri.parse('/reports/analysis');
    final Map<String, dynamic> $params = <String, dynamic>{
      'month': month,
      'year': year,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getDashboardSummary() {
    final Uri $url = Uri.parse('/reports/dashboard');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getNarrative({int? month, int? year}) {
    final Uri $url = Uri.parse('/reports/narrative');
    final Map<String, dynamic> $params = <String, dynamic>{
      'month': month,
      'year': year,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
