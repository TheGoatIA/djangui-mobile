import 'package:chopper/chopper.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/transaction_model.dart';
import '../../../../core/network/models/base_response.dart';

part 'transaction_api_service.chopper.dart';

@ChopperApi()
abstract class TransactionApiService extends ChopperService {
  @Get(path: ApiConstants.transactions)
  Future<Response<BaseListResponse<TransactionModel>>> getTransactions({
    @Query('type') String? type,
    @Query('category') String? category,
    @Query('page') int? page,
  });

  @Get(path: '${ApiConstants.transactions}/{id}')
  Future<Response<BaseResponse<TransactionModel>>> getTransaction(
    @Path('id') String id,
  );

  @Post(path: ApiConstants.transactions)
  Future<Response<BaseResponse<TransactionModel>>> createTransaction(
    @Body() Map<String, dynamic> body,
  );

  @Put(path: '${ApiConstants.transactions}/{id}')
  Future<Response<BaseResponse<TransactionModel>>> updateTransaction(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @Post(path: ApiConstants.transactionsBulk)
  @Multipart()
  Future<Response<BaseResponse<dynamic>>> createBulkTransaction(
    @PartFile('file') String file,
  );

  @Delete(path: '${ApiConstants.transactions}/{id}')
  Future<Response<BaseResponse<dynamic>>> deleteTransaction(
    @Path('id') String id,
  );

  static TransactionApiService create(ChopperClient client) =>
      _$TransactionApiService(client);
}
