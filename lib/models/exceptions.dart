import 'dart:convert';

import 'package:http/http.dart';

abstract class AppException implements Exception {
  String displayMessage();

  @override
  String toString() {
    return displayMessage();
  }
}

class RequestException extends AppException {
  final Response response;

  RequestException(this.response);

  @override
  String displayMessage() {
    final json = {
      'status code': response.statusCode,
      'response': response.body,
    };
    return json.toString();
  }
}
