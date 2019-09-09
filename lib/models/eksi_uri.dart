import 'package:eksi_reader/models/author.dart';
import 'package:eksi_reader/models/section.dart';

class EksiUri {
  static String baseUrl = "https://eksisozluk.com";

  static String getPathForPage(String path, int page) {
    var uri = Uri.parse(path);
    var parameters = new Map<String, String>();
    for (var key in uri.queryParameters.keys) {
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
    int page = 0;
    try {
      var uri = Uri.parse(path);
      for (var key in uri.queryParameters.keys) {
        if (key == 'p') {
          page = int.tryParse(uri.queryParameters[key]);
        }
      }
    } catch (e) {}

    return page;
  }

  static String removePageFromPath(String path) {
    var uri = Uri.parse(path);
    var parameters = new Map<String, String>();
    for (var key in uri.queryParameters.keys) {
      if (key != 'p') {
        parameters.putIfAbsent(key, () => uri.queryParameters[key]);
      }
    }

    var resultUri = Uri(path: uri.path, queryParameters: parameters);
    return parameters.isNotEmpty ? resultUri.toString() : uri.path;
  }

  static String removeFocusToFromPath(String path) {
    var uri = Uri.parse(path);
    var parameters = new Map<String, String>();
    for (var key in uri.queryParameters.keys) {
      if (key != 'focusto') {
        parameters.putIfAbsent(key, () => uri.queryParameters[key]);
      }
    }
    var resultUri = Uri(path: uri.path, queryParameters: parameters);
    return parameters.isNotEmpty ? resultUri.toString() : uri.path;
  }

  static String getAuthorSectionPath(Author author, Section section, int page) {
    if (page == null) {
      page = 1;
    }
    if (section == null) {
      section = new Section(
          title: "entry'ler", path: '/son-entryleri?nick=${author.name}');
    }
    return '${section.path}&p=$page';
  }

  static Author getAuthorFromPath(String path) {
    var uri = Uri.parse(path);
    Author author;
    for (var key in uri.queryParameters.keys) {
      if (key == 'nick') {
        author = Author(name: uri.queryParameters[key], path: path);
      }
    }
    return author;
  }

  static String resetPath(String rootPath, String fullPath) {
    var uri = Uri.parse(fullPath);
    var parameters = new Map<String, String>();
    for (var key in uri.queryParameters.keys) {
      if (key != 'q') {
        parameters.putIfAbsent(key, () => uri.queryParameters[key]);
      }
    }
    var resultUri = Uri(path: rootPath, queryParameters: parameters);
    return resultUri.toString();
  }
}
