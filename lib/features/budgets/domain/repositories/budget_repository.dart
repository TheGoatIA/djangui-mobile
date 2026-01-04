import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/budget_model.dart';

abstract class BudgetRepository {
  Future<Either<Failure, List<BudgetModel>>> getBudgets({
    bool forceRefresh = false,
  });
  Future<Either<Failure, BudgetModel>> createBudget(BudgetModel budget);
  Future<Either<Failure, void>> deleteBudget(String id);
}
