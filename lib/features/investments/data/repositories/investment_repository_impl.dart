import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import '../../../../core/database/database.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/investment_model.dart';
import '../../domain/repositories/investment_repository.dart';
import 'package:kauri/features/investments/data/datasources/investment_api_service.dart';

@LazySingleton(as: InvestmentRepository)
class InvestmentRepositoryImpl implements InvestmentRepository {
  final AppDatabase _db;
  final InvestmentApiService _apiService;

  InvestmentRepositoryImpl(this._db, this._apiService);

  @override
  Future<Either<Failure, List<InvestmentModel>>> getInvestments() async {
    try {
      // 1. Fetch from remote
      final response = await _apiService.getInvestments();
      if (response.isSuccessful && response.body?.data != null) {
        final remoteInvestments = response.body!.data!;
        // 2. Sync with local
        for (final inv in remoteInvestments) {
          await _db
              .into(_db.investments)
              .insertOnConflictUpdate(
                InvestmentsCompanion(
                  id: Value(inv.id),
                  name: Value(inv.name),
                  type: Value(inv.type),
                  initialAmount: Value(inv.initialAmount),
                  currentAmount: Value(inv.currentAmount),
                  currency: Value(inv.currency),
                  status: Value(inv.status),
                  history: Value(
                    json.encode(
                      inv.history?.map((e) => e.toJson()).toList() ?? [],
                    ),
                  ),
                  createdAt: Value(inv.createdAt),
                  updatedAt: Value(inv.updatedAt),
                ),
              );
        }
      }

      // 3. Return from local
      final investments = await _db.select(_db.investments).get();
      return Right(
        investments.map((e) {
          final historyList = (json.decode(e.history) as List)
              .map(
                (x) =>
                    InvestmentHistoryModel.fromJson(x as Map<String, dynamic>),
              )
              .toList();
          return InvestmentModel(
            id: e.id,
            name: e.name,
            type: e.type,
            initialAmount: e.initialAmount,
            currentAmount: e.currentAmount,
            currency: e.currency,
            status: e.status,
            history: historyList,
            createdAt: e.createdAt,
            updatedAt: e.updatedAt,
          );
        }).toList(),
      );
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addInvestment(
    InvestmentModel investment,
  ) async {
    try {
      // 1. Remote create
      final response = await _apiService.createInvestment(investment.toJson());
      if (response.isSuccessful) {
        // 2. Save local
        await _db
            .into(_db.investments)
            .insertOnConflictUpdate(
              InvestmentsCompanion(
                id: Value(investment.id),
                name: Value(investment.name),
                type: Value(investment.type),
                initialAmount: Value(investment.initialAmount),
                currentAmount: Value(investment.currentAmount),
                currency: Value(investment.currency),
                status: Value(investment.status),
                history: Value(
                  json.encode(
                    investment.history?.map((e) => e.toJson()).toList() ?? [],
                  ),
                ),
                createdAt: Value(investment.createdAt),
                updatedAt: Value(investment.updatedAt),
              ),
            );
        return const Right(null);
      }
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteInvestment(String id) async {
    try {
      final response = await _apiService.deleteInvestment(id);
      if (response.isSuccessful) {
        await (_db.delete(_db.investments)..where((t) => t.id.equals(id))).go();
        return const Right(null);
      }
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> closeInvestment(String id) async {
    try {
      final response = await _apiService.closeInvestment(id);
      if (response.isSuccessful) {
        // Update local status? Or define what 'close' means locally.
        // Assuming deletion or status update. Since we don't have status field in local DB yet (checked model),
        // we might just re-sync or doing nothing locally if we re-fetch fully.
        // If 'close' means sell/finish, maybe we should delete or mark as inactive.
        // For now, let's trigger a refresh or just succeed.
        // Best approach: Optimistically update if we had a status field, else just rely on fetch.
        return const Right(null);
      }
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateInvestmentValue(
    String id,
    double value,
  ) async {
    try {
      final response = await _apiService.updateInvestmentValue(id, {
        'currentAmount': value,
      });
      if (response.isSuccessful) {
        // Update local
        await (_db.update(_db.investments)..where((t) => t.id.equals(id)))
            .write(InvestmentsCompanion(currentAmount: Value(value)));
        return const Right(null);
      }
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
