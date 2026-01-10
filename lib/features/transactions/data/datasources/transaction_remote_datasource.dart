import 'package:injectable/injectable.dart';
import 'transaction_api_service.dart';
import '../models/transaction_model.dart';
import '../../../../core/network/api_response_extensions.dart';

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
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<TransactionModel> createTransaction(
    TransactionModel transaction,
  ) async {
    final json = transaction.toJson();
    final Map<String, dynamic> cleanBody = {};
    json.forEach((key, value) {
      if (key != '_id' && key != 'id') {
        cleanBody[key] = value;
      }
    });

    final response = await _apiService.createTransaction(cleanBody);
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final response = await _apiService.deleteTransaction(id);
    if (!response.isSuccessful) {
      throw Exception(response.errorMessage);
    }
  }
}
