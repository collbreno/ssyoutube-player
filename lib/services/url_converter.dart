import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tiktok_mate/services/api_response_parser.dart';

class UrlConverter {
  final _baseUrl = 'https://ssyoutube.com/api/convert';

  Future<String> convert(String url) async {
    final response = await http.post(Uri.parse(_baseUrl), body: _buildParams(url));
    if (response.statusCode != 200) {
      throw Exception(response);
    }

    return ApiResponseParser().getBestLink(jsonDecode(response.body));
  }

  Map<String, dynamic> _buildParams(String url) {
    return {
      'url': url,
    };
  }
}
