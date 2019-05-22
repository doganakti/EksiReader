class EksiUri {
  static String baseUrl = "https://eksisozluk.com";
  
  static String getPathForPage(String path, int page) {
    var uri = Uri.parse(path);
    var parameters = new Map<String, String>();
    for(var key in uri.queryParameters.keys) {
      if (key != 'p') {
        parameters.putIfAbsent(key, () => uri.queryParameters[key]);
      }
    }
    parameters.putIfAbsent('p', () => page.toString());
    var resultUri = Uri(path: uri.path, queryParameters: parameters);
    if (path.contains('/basliklar/bugun/')) {
      resultUri = Uri(path: '/basliklar/bugun/' + page.toString());
    }
    return resultUri.toString();
  }
}
