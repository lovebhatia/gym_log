import 'dart:convert';

class CustomHttpException implements Exception {
  Map<String, dynamic>? errors;

  CustomHttpException(dynamic responseBody) {
    if (responseBody == null) {
      errors = {'unknown error': 'response body is null'};
    } else {
      try {
        errors = {'unknown error': json.decode(responseBody)};
      } catch (e) {
        errors = {'unknown error ': responseBody};
      }
    }
  }

  @override
  String toString() {
    return errors!.values.toList().join(', ');
  }
}
