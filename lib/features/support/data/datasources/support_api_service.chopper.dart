// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'support_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$SupportApiService extends SupportApiService {
  _$SupportApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = SupportApiService;

  @override
  Future<Response<BaseListResponse<SupportTicketModel>>> getTickets() {
    final Uri $url = Uri.parse('/support/tickets');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client
        .send<BaseListResponse<SupportTicketModel>, SupportTicketModel>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<dynamic>>> createTicket(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/support/tickets');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseResponse<dynamic>>> replyToTicket(
    String id,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/support/tickets/${id}/reply');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }
}
