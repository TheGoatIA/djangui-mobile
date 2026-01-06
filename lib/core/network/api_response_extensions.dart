import 'package:chopper/chopper.dart';

extension ResponseExtension on Response {
  /// Extracts a user-friendly error message from the response.
  /// Handles both successful (with message) and error responses.
  String get errorMessage {
    // 1. Try body (for BaseResponse or BaseListResponse)
    final dynamic bodyData = body;
    if (bodyData is Map && bodyData.containsKey('message')) {
      final message = bodyData['message'];
      if (message != null && message.toString().isNotEmpty) {
        return message.toString();
      }
    }

    // 2. Try error property (Chopper puts parsed error body here if isSuccessful is false)
    final dynamic errorData = error;
    if (errorData is Map && errorData.containsKey('message')) {
      final message = errorData['message'];
      if (message != null && message.toString().isNotEmpty) {
        return message.toString();
      }
    }

    // 3. Fallback to status code or default message
    if (error != null) {
      final errorStr = error.toString();
      if (errorStr.isNotEmpty && errorStr != 'null') {
        return errorStr;
      }
    }

    return 'Une erreur inconnue est survenue (Code: $statusCode)';
  }
}
