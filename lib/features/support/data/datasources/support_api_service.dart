import 'package:chopper/chopper.dart';
import '../../../../core/network/models/base_response.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/support_ticket_model.dart';

part 'support_api_service.chopper.dart';

@ChopperApi()
abstract class SupportApiService extends ChopperService {
  @GET(path: ApiConstants.supportTickets)
  Future<Response<BaseListResponse<SupportTicketModel>>> getTickets();

  @POST(path: ApiConstants.supportTickets)
  Future<Response<BaseResponse<dynamic>>> createTicket(
    @Body() Map<String, dynamic> body,
  );

  @POST(path: '${ApiConstants.supportTickets}/{id}/reply')
  Future<Response<BaseResponse<dynamic>>> replyToTicket(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  static SupportApiService create(ChopperClient client) =>
      _$SupportApiService(client);
}
