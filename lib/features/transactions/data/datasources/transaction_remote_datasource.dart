import 'package:injectable/injectable.dart';
import 'transaction_api_service.dart';
import '../models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getTransactions();
  Future<TransactionModel> createTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
}

@LazySingleton(as: TransactionRemoteDataSource)
class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final TransactionApiService _apiService;

  TransactionRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final response = await _apiService.getTransactions();
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(
        response.body?.message ??
            response.error?.toString() ??
            'Failed to fetch transactions',
      );
    }
  }

  @override
  Future<TransactionModel> createTransaction(
    TransactionModel transaction,
  ) async {
    final response = await _apiService.createTransaction(transaction.toJson());
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(
        response.body?.message ??
            response.error?.toString() ??
            'Failed to create transaction',
      );
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final response = await _apiService.deleteTransaction(id);
    if (!response.isSuccessful) {
      throw Exception(
        response.body?.message ??
            response.error?.toString() ??
            'Failed to delete transaction',
      );
    }
  }
}
