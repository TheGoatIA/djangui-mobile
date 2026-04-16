import 'package:chopper/chopper.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/transaction_model.dart';
import '../../../../core/network/models/base_response.dart';

part 'transaction_api_service.chopper.dart';

@ChopperApi()
abstract class TransactionApiService extends ChopperService {
  @GET(path: ApiConstants.transactions)
  Future<Response<BaseListResponse<TransactionModel>>> getTransactions({
    @Query('type') String? type,
    @Query('category') String? category,
    @Query('page') int? page,
  });

  @GET(path: '${ApiConstants.transactions}/{id}')
  Future<Response<BaseResponse<TransactionModel>>> getTransaction(
    @Path('id') String id,
  );

  @POST(path: ApiConstants.transactions)
  Future<Response<BaseResponse<TransactionModel>>> createTransaction(
    @Body() Map<String, dynamic> body,
  );

  @PUT(path: '${ApiConstants.transactions}/{id}')
  Future<Response<BaseResponse<TransactionModel>>> updateTransaction(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @POST(path: ApiConstants.transactionsBulk)
  @Multipart()
  Future<Response<BaseResponse<dynamic>>> createBulkTransaction(
    @PartFile('file') String file,
  );

  @DELETE(path: '${ApiConstants.transactions}/{id}')
  Future<Response<BaseResponse<dynamic>>> deleteTransaction(
    @Path('id') String id,
  );

  static TransactionApiService create(ChopperClient client) =>
      _$TransactionApiService(client);
}
