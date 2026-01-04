// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ReportsApiService extends ReportsApiService {
  _$ReportsApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ReportsApiService;

  @override
  Future<Response<BaseResponse<DashboardReportModel>>> getDashboardReport() {
    final Uri $url = Uri.parse('/reports/dashboard');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<BaseResponse<DashboardReportModel>,
        DashboardReportModel>($request);
  }

  @override
  Future<Response<BaseListResponse<SpendingAnalysisModel>>>
      getSpendingAnalysis() {
    final Uri $url = Uri.parse('/reports/analysis');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<BaseListResponse<SpendingAnalysisModel>,
        SpendingAnalysisModel>($request);
  }

  @override
  Future<Response<BaseListResponse<SavingsTrendModel>>> getSavingsTrend() {
    final Uri $url = Uri.parse('/reports/trends');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client
        .send<BaseListResponse<SavingsTrendModel>, SavingsTrendModel>($request);
  }

  @override
  Future<Response<BaseResponse<NarrativeReportModel>>> getNarrativeReport() {
    final Uri $url = Uri.parse('/reports/narrative');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<BaseResponse<NarrativeReportModel>,
        NarrativeReportModel>($request);
  }

  @override
  Future<Response<dynamic>> exportCsv() {
    final Uri $url = Uri.parse('/reports/export/csv');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
