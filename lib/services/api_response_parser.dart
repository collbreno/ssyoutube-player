class ApiResponseParser {
  String getBestLink(Map<String, dynamic> data) {
    final urlObjs = data['url'] as List<dynamic>;
    final bestObj = urlObjs.reduce((curr, next) {
      return next['type'] == 'mp4' && _toInt(next['quality']) > _toInt(curr['quality'])
          ? next
          : curr;
    });

    return bestObj['url'];
  }

  int _toInt(dynamic n) {
    return n.runtimeType == String ? int.parse(n) : n;
  }
}
