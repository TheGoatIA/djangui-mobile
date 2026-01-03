import 'package:chopper/chopper.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/transaction_model.dart';

part 'transaction_api_service.chopper.dart';

@ChopperApi()
abstract class TransactionApiService extends ChopperService {
  @Get(path: ApiConstants.transactions)
  Future<Response<List<TransactionModel>>> getTransactions({
    @Query('type') String? type,
    @Query('category') String? category,
    @Query('page') int? page,
  });

  @Post(path: ApiConstants.transactions)
  Future<Response<TransactionModel>> createTransaction(
    @Body() Map<String, dynamic> body,
  );

  @Post(path: ApiConstants.transactionsBulk)
  @Multipart()
  Future<Response<dynamic>> createBulkTransaction(
    @PartFile('file') String file,
  );

  @Delete(path: '${ApiConstants.transactions}/{id}')
  Future<Response<void>> deleteTransaction(@Path('id') String id);

  static TransactionApiService create(ChopperClient client) =>
      _$TransactionApiService(client);
}
