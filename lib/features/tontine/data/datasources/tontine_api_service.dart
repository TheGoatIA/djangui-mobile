import 'package:chopper/chopper.dart';
import 'package:http/http.dart' show MultipartFile;
import '../../../../core/network/models/base_response.dart';
import '../models/tontine_model.dart';

part 'tontine_api_service.chopper.dart';

@ChopperApi(baseUrl: '/tontines')
abstract class TontineApiService extends ChopperService {
  static TontineApiService create([ChopperClient? client]) =>
      _$TontineApiService(client);

  @POST()
  Future<Response<BaseResponse<TontineModel>>> createTontine(
    @Body() Map<String, dynamic> body,
  );

  @GET()
  Future<Response<BaseListResponse<TontineModel>>> getTontines();

  @GET(path: '/{id}')
  Future<Response<BaseResponse<TontineModel>>> getTontineDetails(
    @Path('id') String id,
  );

  @PATCH(path: '/{id}')
  Future<Response<BaseResponse<TontineModel>>> updateTontine(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE(path: '/{id}')
  Future<Response<BaseResponse<dynamic>>> deleteTontine(@Path('id') String id);

  @POST(path: '/join')
  Future<Response<BaseResponse<TontineMemberModel>>> joinTontine(
    @Body() Map<String, dynamic> body,
  );

  @GET(path: '/{id}/members')
  Future<Response<BaseListResponse<TontineMemberModel>>> getTontineMembers(
    @Path('id') String id,
  );

  @POST(path: '/contribute')
  @Multipart()
  Future<Response<BaseResponse<TontineContributionModel>>> contribute({
    @Part('tontineId') required String tontineId,
    @PartFile('receipt') required MultipartFile proofImage,
  });

  @GET(path: '/{id}/messages')
  Future<Response<BaseListResponse<TontineMessageModel>>> getTontineMessages(
    @Path('id') String id,
  );

  @POST(path: '/{id}/messages')
  Future<Response<BaseResponse<TontineMessageModel>>> sendMessage(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @GET(path: '/{id}/contributions')
  Future<Response<BaseListResponse<TontineContributionModel>>> getContributions(
    @Path('id') String id,
  );

  @POST(path: '/contributions/{id}/validate')
  Future<Response<BaseResponse<TontineContributionModel>>> validateContribution(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @GET(path: '/{id}/export')
  Future<Response<List<int>>> exportTontine(@Path('id') String id);

  @POST(path: '/{id}/start')
  Future<Response<BaseResponse<TontineModel>>> startTontine(
    @Path('id') String id,
  );

  @DELETE(path: '/{id}/members/{memberId}')
  Future<Response<BaseResponse<dynamic>>> removeMember(
    @Path('id') String id,
    @Path('memberId') String memberId,
  );

  @POST(path: '/{id}/rotation/next')
  Future<Response<BaseResponse<TontineModel>>> rotateTurn(
    @Path('id') String id,
  );

  @PATCH(path: '/{id}/members/{memberId}/auto-debit/toggle')
  Future<Response<BaseResponse<TontineMemberModel>>> toggleAutoDebit(
    @Path('id') String id,
    @Path('memberId') String memberId,
    @Body() Map<String, dynamic> body,
  );
}
