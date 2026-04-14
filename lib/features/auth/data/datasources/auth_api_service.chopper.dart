// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'auth_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AuthApiService extends AuthApiService {
  _$AuthApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AuthApiService;

  @override
  Future<Response<BaseResponse<AuthResponse>>> login(LoginRequest body) {
    final Uri $url = Uri.parse('/auth/login');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BaseResponse<AuthResponse>, AuthResponse>($request);
  }

  @override
  Future<Response<BaseResponse<Map<String, dynamic>>>> submitKYC(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/fintech/kyc/submit');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client
        .send<BaseResponse<Map<String, dynamic>>, Map<String, dynamic>>(
          $request,
        );
  }

  @override
  Future<Response<AuthResponse>> firebaseLogin(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/auth/firebase');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<AuthResponse, AuthResponse>($request);
  }

  @override
  Future<Response<AuthResponse>> appleLogin(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/auth/apple');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<AuthResponse, AuthResponse>($request);
  }

  @override
  Future<Response<BaseResponse<Map<String, dynamic>>>> refreshToken(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/auth/refresh');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client
        .send<BaseResponse<Map<String, dynamic>>, Map<String, dynamic>>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<dynamic>>> logout() {
    final Uri $url = Uri.parse('/auth/logout');
    final Request $request = Request('POST', $url, client.baseUrl);
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseResponse<dynamic>>> updateFcmToken(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/auth/fcm-token');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseResponse<dynamic>>> linkPhone(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/auth/link-phone');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseResponse<AuthResponse>>> register(RegisterRequest body) {
    final Uri $url = Uri.parse('/auth/register');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BaseResponse<AuthResponse>, AuthResponse>($request);
  }

  @override
  Future<Response<BaseResponse<dynamic>>> forgotPassword(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/auth/forgot-password');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseResponse<dynamic>>> resetPassword(
    String token,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/auth/reset-password/${token}');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseResponse<dynamic>>> verifyEmail(String token) {
    final Uri $url = Uri.parse('/auth/verify-email');
    final Map<String, dynamic> $params = <String, dynamic>{'token': token};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseResponse<Map<String, dynamic>>>> getUserProfile() {
    final Uri $url = Uri.parse('/auth/me');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client
        .send<BaseResponse<Map<String, dynamic>>, Map<String, dynamic>>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<Map<String, dynamic>>>> updateProfile(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/auth/me');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<BaseResponse<Map<String, dynamic>>, Map<String, dynamic>>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<dynamic>>> updateDeviceInfo(
    DeviceInfoRequest body,
  ) {
    final Uri $url = Uri.parse('/auth/device');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseResponse<dynamic>>> changePassword(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/auth/change-password');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseResponse<dynamic>>> deleteAccount() {
    final Uri $url = Uri.parse('/auth/delete-me');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseResponse<Map<String, dynamic>>>> getSessions() {
    final Uri $url = Uri.parse('/auth/sessions');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client
        .send<BaseResponse<Map<String, dynamic>>, Map<String, dynamic>>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<dynamic>>> revokeAllOtherSessions() {
    final Uri $url = Uri.parse('/auth/sessions');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseResponse<dynamic>>> revokeSession(String sessionId) {
    final Uri $url = Uri.parse('/auth/sessions/${sessionId}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseResponse<dynamic>>> logConnection(
    ConnectionRequest body,
  ) {
    final Uri $url = Uri.parse('/auth/connection');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseResponse<CountryChangeRequestModel>>>
  requestCountryChange(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/auth/request-country-change');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<
      BaseResponse<CountryChangeRequestModel>,
      CountryChangeRequestModel
    >($request);
  }

  @override
  Future<Response<BaseResponse<dynamic>>> updateLanguage(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/auth/language');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }
}
