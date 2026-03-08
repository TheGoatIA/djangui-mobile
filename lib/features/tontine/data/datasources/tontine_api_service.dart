import 'package:chopper/chopper.dart';
import 'package:http/http.dart' show MultipartFile;
import '../../../../core/network/models/base_response.dart';
import '../models/tontine_model.dart';

part 'tontine_api_service.chopper.dart';

@ChopperApi(baseUrl: '/tontines')
abstract class TontineApiService extends ChopperService {
  static TontineApiService create([ChopperClient? client]) =>
      _$TontineApiService(client);

  @Post()
  Future<Response<BaseResponse<TontineModel>>> createTontine(
    @Body() Map<String, dynamic> body,
  );

  @Get()
  Future<Response<BaseListResponse<TontineModel>>> getTontines();

  @Get(path: '/{id}')
  Future<Response<BaseResponse<TontineModel>>> getTontineDetails(
    @Path('id') String id,
  );

  @Patch(path: '/{id}')
  Future<Response<BaseResponse<TontineModel>>> updateTontine(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @Delete(path: '/{id}')
  Future<Response<BaseResponse<dynamic>>> deleteTontine(@Path('id') String id);

  @Post(path: '/join')
  Future<Response<BaseResponse<TontineMemberModel>>> joinTontine(
    @Body() Map<String, dynamic> body,
  );

  @Get(path: '/{id}/members')
  Future<Response<BaseListResponse<TontineMemberModel>>> getTontineMembers(
    @Path('id') String id,
  );

  @Post(path: '/contribute')
  @Multipart()
  Future<Response<BaseResponse<TontineContributionModel>>> contribute({
    @Part('tontineId') required String tontineId,
    @PartFile('receipt') required MultipartFile proofImage,
  });

  @Get(path: '/{id}/messages')
  Future<Response<BaseListResponse<TontineMessageModel>>> getTontineMessages(
    @Path('id') String id,
  );

  @Post(path: '/{id}/messages')
  Future<Response<BaseResponse<TontineMessageModel>>> sendMessage(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @Get(path: '/{id}/contributions')
  Future<Response<BaseListResponse<TontineContributionModel>>> getContributions(
    @Path('id') String id,
  );

  @Post(path: '/contributions/{id}/validate')
  Future<Response<BaseResponse<TontineContributionModel>>> validateContribution(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @Get(path: '/{id}/export')
  Future<Response<List<int>>> exportTontine(@Path('id') String id);

  @Post(path: '/{id}/start')
  Future<Response<BaseResponse<TontineModel>>> startTontine(
    @Path('id') String id,
  );

  @Delete(path: '/{id}/members/{memberId}')
  Future<Response<BaseResponse<dynamic>>> removeMember(
    @Path('id') String id,
    @Path('memberId') String memberId,
  );

  @Post(path: '/{id}/rotation/next')
  Future<Response<BaseResponse<TontineModel>>> rotateTurn(
    @Path('id') String id,
  );

  @Patch(path: '/{id}/members/{memberId}/auto-debit/toggle')
  Future<Response<BaseResponse<TontineMemberModel>>> toggleAutoDebit(
    @Path('id') String id,
    @Path('memberId') String memberId,
    @Body() Map<String, dynamic> body,
  );
}
