import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/budget_model.dart';
import '../../data/models/auto_budget_response.dart';

abstract class BudgetRepository {
  Future<Either<Failure, List<BudgetModel>>> getBudgets({
    bool forceRefresh = false,
  });
  Future<Either<Failure, BudgetModel>> createBudget(BudgetModel budget);
  Future<Either<Failure, BudgetModel>> updateBudget(BudgetModel budget);
  Future<Either<Failure, void>> deleteBudget(String id);
  Future<Either<Failure, AutoBudgetResponse>> generateAutoBudget({
    int? month,
    int? year,
  });
}
