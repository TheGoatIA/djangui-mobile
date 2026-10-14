import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kauri/core/network/tracing_http_client.dart';
import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/di/injection.dart';

void main() {
  setUp(() {
    if (getIt.isRegistered<TelemetryService>()) {
      getIt.unregister<TelemetryService>();
    }
    getIt.registerSingleton<TelemetryService>(TelemetryService());
  });

  tearDown(() {
    if (getIt.isRegistered<TelemetryService>()) {
      getIt.unregister<TelemetryService>();
    }
  });

  group('TracingHttpClient Tests', () {
    test('preserves and transmits MultipartRequest files and fields with traceparent', () async {
      http.BaseRequest? capturedRequest;
      String? capturedBody;

      final mockInner = MockClient.streaming((request, bodyStream) async {
        capturedRequest = request;
        final bytes = await bodyStream.toBytes();
        capturedBody = utf8.decode(bytes, allowMalformed: true);
        return http.StreamedResponse(
          Stream.value(utf8.encode('{"success": true}')),
          200,
        );
      });

      final tracingClient = TracingHttpClient(inner: mockInner);

      final multipartRequest = http.MultipartRequest(
        'POST',
        Uri.parse('http://example.com/upload/document'),
      );
      multipartRequest.fields['title'] = 'CNI Front';
      multipartRequest.files.add(
        http.MultipartFile.fromString(
          'document',
          'dummy file binary content',
          filename: 'cni.jpg',
        ),
      );

      final response = await tracingClient.send(multipartRequest);

      expect(response.statusCode, 200);
      expect(capturedRequest, isA<http.MultipartRequest>());

      final receivedMultipart = capturedRequest as http.MultipartRequest;
      expect(receivedMultipart.fields['title'], 'CNI Front');
      expect(receivedMultipart.files.length, 1);
      expect(receivedMultipart.files.first.field, 'document');
      expect(receivedMultipart.files.first.filename, 'cni.jpg');
      expect(receivedMultipart.headers.containsKey('traceparent'), isTrue);
      expect(capturedBody?.contains('dummy file binary content'), isTrue);
      expect(capturedBody?.contains('name="document"'), isTrue);
    });

    test('preserves standard Request and injects traceparent header', () async {
      http.BaseRequest? capturedRequest;

      final mockInner = MockClient((request) async {
        capturedRequest = request;
        return http.Response('{"status": "ok"}', 200);
      });

      final tracingClient = TracingHttpClient(inner: mockInner);

      final standardRequest = http.Request(
        'GET',
        Uri.parse('http://example.com/api/v1/user'),
      );
      standardRequest.headers['Authorization'] = 'Bearer token123';

      final response = await tracingClient.send(standardRequest);

      expect(response.statusCode, 200);
      expect(capturedRequest?.headers['Authorization'], 'Bearer token123');
      expect(capturedRequest?.headers.containsKey('traceparent'), isTrue);
    });
  });
}
