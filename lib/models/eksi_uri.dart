import 'package:eksi_reader/models/author.dart';
import 'package:eksi_reader/models/section.dart';

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

  static int getPageFromPath(String path) {
    var uri = Uri.parse(path);
    int page = 0;
    for(var key in uri.queryParameters.keys) {
      if (key == 'p') {
        page = int.tryParse(uri.queryParameters[key]);
      }
    }
   return page;
  }

  static String removePageFromPath(String path) {
    var uri = Uri.parse(path);
    var parameters = new Map<String, String>();
    for(var key in uri.queryParameters.keys) {
      if (key != 'p') {
        parameters.putIfAbsent(key, () => uri.queryParameters[key]);
      }
    }
    
    var resultUri = Uri(path: uri.path, queryParameters: parameters);
    return parameters.length > 0 ? resultUri.toString() : uri.path;
  }

  static String getAuthorSectionPath(Author author, Section section, int page) {
    if (page == null) {
      page = 1;
    }
    if (section == null) {
      section = new Section(title: "entry'ler", path: '/son-entryleri?nick=${author.name}');
    }
    return '${section.path}&p=$page';
  }
}
