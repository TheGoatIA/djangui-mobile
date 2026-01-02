import 'package:chopper/chopper.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/transaction_model.dart';

part 'transaction_api_service.chopper.dart';

@ChopperApi()
abstract class TransactionApiService extends ChopperService {
  @Get(path: ApiConstants.transactions)
  Future<Response<List<TransactionModel>>> getTransactions();

  @Post(path: ApiConstants.transactions)
  Future<Response<TransactionModel>> createTransaction(
    @Body() Map<String, dynamic> body,
  );

  @Delete(path: '${ApiConstants.transactions}/{id}')
  Future<Response<void>> deleteTransaction(@Path('id') String id);

  static TransactionApiService create(ChopperClient client) =>
      _$TransactionApiService(client);
}
