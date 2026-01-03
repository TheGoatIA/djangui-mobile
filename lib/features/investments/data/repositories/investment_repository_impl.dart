import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/database.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/investment_model.dart';
import '../../domain/repositories/investment_repository.dart';

@LazySingleton(as: InvestmentRepository)
class InvestmentRepositoryImpl implements InvestmentRepository {
  final AppDatabase _db;

  InvestmentRepositoryImpl(this._db);

  @override
  Future<Either<Failure, List<InvestmentModel>>> getInvestments() async {
    try {
      final investments = await _db.select(_db.investments).get();
      return Right(
        investments
            .map(
              (e) => InvestmentModel(
                id: e.id,
                name: e.name,
                type: e.type,
                initialAmount: e.initialAmount,
                currentAmount: e.currentAmount,
                roi: e.roi,
                date: e.date,
                notes: e.notes,
              ),
            )
            .toList(),
      );
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addInvestment(
    InvestmentModel investment,
  ) async {
    try {
      await _db
          .into(_db.investments)
          .insert(
            InvestmentsCompanion(
              id: Value(investment.id),
              name: Value(investment.name),
              type: Value(investment.type),
              initialAmount: Value(investment.initialAmount),
              currentAmount: Value(investment.currentAmount),
              roi: Value(investment.roi),
              date: Value(investment.date),
              notes: Value(investment.notes),
            ),
          );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteInvestment(String id) async {
    try {
      await (_db.delete(_db.investments)..where((t) => t.id.equals(id))).go();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
