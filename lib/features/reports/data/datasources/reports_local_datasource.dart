import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/database.dart';
import '../models/reports_model.dart';

abstract class ReportsLocalDataSource {
  Future<DashboardReportModel?> getCachedDashboardReport();
  Future<void> saveDashboardReport(DashboardReportModel report);

  Future<List<SpendingAnalysisModel>?> getCachedSpendingAnalysis(
    String period,
  );
  Future<void> saveSpendingAnalysis(
    String period,
    List<SpendingAnalysisModel> data,
  );

  Future<List<SavingsTrendModel>?> getCachedSavingsTrend(String period);
  Future<void> saveSavingsTrend(String period, List<SavingsTrendModel> data);

  Future<NarrativeReportModel?> getCachedNarrativeReport();
  Future<void> saveNarrativeReport(NarrativeReportModel report);

  Future<ForecastReportModel?> getCachedBalanceForecast();
  Future<void> saveBalanceForecast(ForecastReportModel forecast);

  Future<List<HealthScorePointModel>?> getCachedHealthScoreHistory();
  Future<void> saveHealthScoreHistory(List<HealthScorePointModel> history);
}

@LazySingleton(as: ReportsLocalDataSource)
class ReportsLocalDataSourceImpl implements ReportsLocalDataSource {
  final AppDatabase _db;

  ReportsLocalDataSourceImpl(this._db);

  @override
  Future<DashboardReportModel?> getCachedDashboardReport() async {
    final row = await (_db.select(
      _db.dashboardReports,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
    if (row == null) return null;

    return DashboardReportModel(
      walletBalance: row.walletBalance,
      monthlyIncome: row.monthlyIncome,
      totalSpent: row.totalSpent,
      savingsRate: row.savingsRate,
      currency: row.currency,
      budgetHealth: row.budgetHealth != null
          ? BudgetHealthModel.fromJson(
              json.decode(row.budgetHealth!) as Map<String, dynamic>,
            )
          : null,
    );
  }

  @override
  Future<void> saveDashboardReport(DashboardReportModel report) async {
    await _db
        .into(_db.dashboardReports)
        .insertOnConflictUpdate(
          DashboardReportsCompanion.insert(
            id: const Value(1),
            walletBalance: report.walletBalance,
            monthlyIncome: report.monthlyIncome,
            totalSpent: report.totalSpent,
            savingsRate: report.savingsRate,
            currency: Value(report.currency),
            budgetHealth: Value(
              report.budgetHealth != null
                  ? json.encode(report.budgetHealth!.toJson())
                  : null,
            ),
            cachedAt: DateTime.now(),
          ),
        );
  }

  @override
  Future<List<SpendingAnalysisModel>?> getCachedSpendingAnalysis(
    String period,
  ) async {
    final row = await (_db.select(
      _db.spendingAnalysisCache,
    )..where((t) => t.period.equals(period))).getSingleOrNull();
    if (row == null) return null;
    final list = json.decode(row.dataJson) as List<dynamic>;
    return list
        .map((e) => SpendingAnalysisModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveSpendingAnalysis(
    String period,
    List<SpendingAnalysisModel> data,
  ) async {
    await _db
        .into(_db.spendingAnalysisCache)
        .insertOnConflictUpdate(
          SpendingAnalysisCacheCompanion.insert(
            period: period,
            dataJson: json.encode(data.map((e) => e.toJson()).toList()),
            cachedAt: DateTime.now(),
          ),
        );
  }

  @override
  Future<List<SavingsTrendModel>?> getCachedSavingsTrend(
    String period,
  ) async {
    final row = await (_db.select(
      _db.savingsTrendCache,
    )..where((t) => t.period.equals(period))).getSingleOrNull();
    if (row == null) return null;
    final list = json.decode(row.dataJson) as List<dynamic>;
    return list
        .map((e) => SavingsTrendModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveSavingsTrend(
    String period,
    List<SavingsTrendModel> data,
  ) async {
    await _db
        .into(_db.savingsTrendCache)
        .insertOnConflictUpdate(
          SavingsTrendCacheCompanion.insert(
            period: period,
            dataJson: json.encode(data.map((e) => e.toJson()).toList()),
            cachedAt: DateTime.now(),
          ),
        );
  }

  @override
  Future<NarrativeReportModel?> getCachedNarrativeReport() async {
    final row = await (_db.select(
      _db.narrativeReportCache,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
    if (row == null) return null;
    return NarrativeReportModel.fromJson(
      json.decode(row.dataJson) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> saveNarrativeReport(NarrativeReportModel report) async {
    await _db
        .into(_db.narrativeReportCache)
        .insertOnConflictUpdate(
          NarrativeReportCacheCompanion.insert(
            id: const Value(1),
            dataJson: json.encode(report.toJson()),
            cachedAt: DateTime.now(),
          ),
        );
  }

  @override
  Future<ForecastReportModel?> getCachedBalanceForecast() async {
    final row = await (_db.select(
      _db.forecastCache,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
    if (row == null) return null;
    return ForecastReportModel.fromJson(
      json.decode(row.dataJson) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> saveBalanceForecast(ForecastReportModel forecast) async {
    await _db
        .into(_db.forecastCache)
        .insertOnConflictUpdate(
          ForecastCacheCompanion.insert(
            id: const Value(1),
            dataJson: json.encode(forecast.toJson()),
            cachedAt: DateTime.now(),
          ),
        );
  }

  @override
  Future<List<HealthScorePointModel>?> getCachedHealthScoreHistory() async {
    final row = await (_db.select(
      _db.healthScoreHistoryCache,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
    if (row == null) return null;
    final list = json.decode(row.dataJson) as List<dynamic>;
    return list
        .map((e) => HealthScorePointModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveHealthScoreHistory(
    List<HealthScorePointModel> history,
  ) async {
    await _db
        .into(_db.healthScoreHistoryCache)
        .insertOnConflictUpdate(
          HealthScoreHistoryCacheCompanion.insert(
            id: const Value(1),
            dataJson: json.encode(history.map((e) => e.toJson()).toList()),
            cachedAt: DateTime.now(),
          ),
        );
  }
}
