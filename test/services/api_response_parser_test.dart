import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_mate/services/api_response_parser.dart';

void main() {
  final parser = ApiResponseParser();

  test('getBestLink method must work for instagram1', () async {
    final file = File('test/resources/instagram1.json');
    final json = jsonDecode(await file.readAsString());

    expect(
      parser.getBestLink(json),
      'best_link_instagram1',
    );
  });
  test('getBestLink method must work for tiktok1', () async {
    final file = File('test/resources/tiktok1.json');
    final json = jsonDecode(await file.readAsString());

    expect(
      parser.getBestLink(json),
      'best_link_tiktok1',
    );
  });
  test('getBestLink method must work for twitter1', () async {
    final file = File('test/resources/twitter1.json');
    final json = jsonDecode(await file.readAsString());

    expect(
      parser.getBestLink(json),
      'best_link_twitter1',
    );
  });
  test('getBestLink method must work for twitter2', () async {
    final file = File('test/resources/twitter2.json');
    final json = jsonDecode(await file.readAsString());

    expect(
      parser.getBestLink(json),
      'best_link_twitter2',
    );
  });
  test('getBestLink method must work for youtube1', () async {
    final file = File('test/resources/youtube1.json');
    final json = jsonDecode(await file.readAsString());

    expect(
      parser.getBestLink(json),
      'best_link_youtube1',
    );
  });
  test('getBestLink method must work for youtube2', () async {
    final file = File('test/resources/youtube2.json');
    final json = jsonDecode(await file.readAsString());

    expect(
      parser.getBestLink(json),
      'best_link_youtube2',
    );
  });

}
