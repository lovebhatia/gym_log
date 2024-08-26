import 'dart:convert';

class CustomHttpException implements Exception {
  final String message;

  CustomHttpException(dynamic responseBody) : message = _parseMessage(responseBody);

  static String _parseMessage(dynamic responseBody) {
    if (responseBody == null) {
      return 'Unknown error: response body is null';
    }
    try {
      final decoded = json.decode(responseBody);
      return decoded['message'] ?? 'Unknown error';
    } catch (e) {
      return 'Invalid response format: ${responseBody.toString()}';
    }
  }

  @override
  String toString() {
    return message;
  }
}
