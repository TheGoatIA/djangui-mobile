// GENERATED CODE - DO NOT MODIFY BY HAND

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
  Future<Response<List<CategoryDistributionModel>>> getCategoryDistribution(
      String period) {
    final Uri $url = Uri.parse('/insights/distribution');
    final Map<String, dynamic> $params = <String, dynamic>{'period': period};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<CategoryDistributionModel>,
        CategoryDistributionModel>($request);
  }

  @override
  Future<Response<List<SpendingTrendModel>>> getSpendingTrends(String period) {
    final Uri $url = Uri.parse('/insights/trends');
    final Map<String, dynamic> $params = <String, dynamic>{'period': period};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<SpendingTrendModel>, SpendingTrendModel>($request);
  }
}
