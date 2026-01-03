import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/investment_model.dart';

abstract class InvestmentRepository {
  Future<Either<Failure, List<InvestmentModel>>> getInvestments();
  Future<Either<Failure, void>> addInvestment(InvestmentModel investment);
  Future<Either<Failure, void>> deleteInvestment(String id);
}
