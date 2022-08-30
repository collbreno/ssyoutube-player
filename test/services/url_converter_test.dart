import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_mate/services/url_converter.dart';
import 'package:http/http.dart' as http;

void main() {
  final converter = UrlConverter();

  test('instagram', () async {
    const url = 'https://www.instagram.com/p/Ch3BvDMMSHj/';
    final videoUrl = await converter.convert(url);
    final response = await http.head(Uri.parse(videoUrl));

    expect(response.statusCode, 200);
    expect(response.headers['content-type'], 'video/mp4');
  });

  test('tiktok', () async {
    const url = 'https://www.tiktok.com/@noproblemgambler/video/7095908054025145606';
    final videoUrl = await converter.convert(url);
    final response = await http.head(Uri.parse(videoUrl));

    expect(response.statusCode, 200);
    expect(response.headers['content-type'], 'video/mp4');
  });

  test('twitter', () async {
    const url = 'https://twitter.com/TweetsOfCats/status/1563978212950032391?t=n5AbZy3SgxiiJIhds-zEuA&s=19';
    final videoUrl = await converter.convert(url);
    final response = await http.head(Uri.parse(videoUrl));

    expect(response.statusCode, 200);
    expect(response.headers['content-type'], 'video/mp4');
  });

  test('youtube', () async {
    const url = 'https://www.youtube.com/watch?v=lOrEFMG7gWs';
    final videoUrl = await converter.convert(url);
    final response = await http.head(Uri.parse(videoUrl));

    expect(response.statusCode, 200);
    expect(response.headers['content-type'], 'video/mp4');
  });
}
