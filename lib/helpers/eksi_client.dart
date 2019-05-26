import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eksi_reader/models/user.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class EksiClient {
  var _headers = {
    'user-agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36'
  };
  String _url = 'https://eksisozluk.com';

  EksiClient() {
    var flutterWebviewPlugin = FlutterWebviewPlugin();
    flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      var username = await flutterWebviewPlugin
          .evalJavascript("document.getElementById('username').value");
      var password = await flutterWebviewPlugin
          .evalJavascript("document.getElementById('password').value");
      if (username != '(null)' && username != '') {
        print('username: ' + username);
        print('password: ' + password);
        await FlutterKeychain.put(key: "username", value: username);
        await FlutterKeychain.put(key: "password", value: password);
      }
    });
  }

  Future<Document> get(
      {String path: '/basliklar/gundem', bool cacheCookies: false, bool subContent}) async {
    var client = new Dio();
    var headers = _headers;
    if (subContent != null) {
      headers['x-requested-with'] = 'XMLHttpRequest';
    } else {
      headers['x-requested-with'] = null;
    }
    var response = await client.get(_url + path, options: Options(headers: headers));
    if (cacheCookies) {
      var setCookies = response.headers['set-cookie'];
      setHeaders(setCookies);
    }
    var document = parse(response.data);
    return document;
  }

  void setHeaders(List<String> rawCookies) {
    String cookieString = '';
    for (var rawCookie in rawCookies) {
      int index = rawCookie.indexOf(';');
      cookieString = cookieString +
          ((index == -1) ? rawCookie : rawCookie.substring(0, index)) +
          ';';
    }
    _headers = {
      'user-agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36',
      'cookie': cookieString
    };
  }

  Future<User> getUser() async {
    var login = await FlutterKeychain.get(key: "username");
    var password = await FlutterKeychain.get(key: "password");
    if (login != null && password != null) {
      return new User(login: login, password: password);
    } else {
      return null;
    }
  }

  Future<String> getToken() async {
    var document = await get(path: '/giris', cacheCookies: true);
    var content = document.querySelector("#content-body");
    var formContainer = content.querySelector(".form-container");
    var tokenInput = formContainer.querySelector("input");
    var token = tokenInput.attributes['value'];
    return token;
  }

  Future<bool> login() async {
    var user = await getUser();
    if (user != null) {
      var token = await getToken();
      var formData = {
        '__RequestVerificationToken': token,
        'ReturnUrl': 'https://eksisozluk.com/',
        'UserName': user.login,
        'Password': user.password,
        'RememberMe': 'true'
      };
      var dioClient = new Dio();
      var response = await dioClient.post("https://eksisozluk.com/giris",
          data: formData,
          options: Options(
              headers: _headers,
              followRedirects: false,
              validateStatus: (int status) {
                print("status code = $status");
                return status < 500;
              },
              contentType:
                  ContentType.parse("application/x-www-form-urlencoded")));
      var setCookies = response.headers['set-cookie'];
      setHeaders(setCookies);
    }
    return true;
  }

  Future<dynamic> readResponse(HttpClientResponse response) {
    var completer = new Completer();
    var contents = new StringBuffer();
    response.transform(utf8.decoder).listen((String data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }
}
