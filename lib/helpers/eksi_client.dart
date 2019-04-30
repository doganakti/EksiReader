import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eksi_reader/models/user.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:http/http.dart';
import 'package:requests/requests.dart';

class EksiClient {
  HttpClient _client = new HttpClient();
  Map<String, String> _cookies = new Map<String, String>();
  CookieJar _cookieJar = new CookieJar();

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
      if (true) {
        // print('username: ' + username);
        // print('password: ' + password);
        // await FlutterKeychain.put(key: "username", value: username);
        // await FlutterKeychain.put(key: "password", value: password);
        _cookies = await flutterWebviewPlugin.getCookies();
        //print(_cookies);
        var cookieString = '';
        List<Cookie> cookies = new List<Cookie>();
        bool contains = _cookies.keys.contains('ASP.NET_SessionId');
        for (var key in _cookies.keys) {
          try {
            var value = _cookies[key];
            print(key);
            var cookiePart =key.trim() + '=' + value.trim() + '; ';
            cookieString = cookieString  + cookiePart;
          } catch (e) {
            print(e);
          }
        }
        if (cookieString.length > 1) {
          cookieString = cookieString.substring(0, cookieString.length - 2);
        }
        //print(cookieString);

        // _cookieJar.saveFromResponse(
        //     Uri.parse("https://eksisozluk.com"), cookies);
      }
    });
  }

  Future<Document> get(path) async {
    // var response = await _client.get(_url + path, headers: _headers);
    // var document = parse(response.body);
    // return document;
    // var response =
    //     await _client.get(_url + path, options: new Options(headers: _headers));
    // var document = parse(response.data);
    // var jar = _client.interceptors.first;
    // print(jar);

    // return document;

    // HttpClient client = new HttpClient();
    // HttpClientRequest clientRequest = await client.getUrl(Uri.parse(_url + path));
    // if (_cookies != null && _cookies.length > 0) {
    //   for (var key in _cookies.keys) {
    //     var value = _cookies[key];
    //     clientRequest.cookies.add(Cookie(key.trim(), value.trim()));
    //   }
    // }
    // clientRequest.headers.add(HttpHeaders.userAgentHeader, "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36");
    // HttpClientResponse clientResponse = await clientRequest.close();
    // var document = new Document();
    // clientResponse.transform(utf8.decoder).listen((body) {
    //   document = parse(body);
    //   print(document.text);
    //   return document;
    // });
    String body = await Requests.get(_url + path, headers: _headers);
    var document = parse(body);
    return document;
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
    var document = await get('/giris');
    var content = document.querySelector("#content-body");
    var formContainer = content.querySelector(".form-container");
    var tokenInput = formContainer.querySelector("input");
    var token = tokenInput.attributes['value'];
    return token;
  }

  Future<bool> login() async {
    var user = await getUser();
    var token = await getToken();
    print(token);
    Map<String, String> jsonMap = {
      '__RequestVerificationToken': token,
      'ReturnUrl': 'https://eksisozluk.com/',
      'UserName': user.login,
      'Password': user.password,
      'RememberMe': 'true'
    };
    var response = await post(Uri.parse(_url + '/giris'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36'
        },
        body: json.encode(jsonMap),
        encoding: Encoding.getByName("utf-8"));
    print(response.body);
    return response != null;
    // var body2 = json.encode(body);
    // var result = await Requests.post(_url + '/giris', headers: {'user-agent': _headers['user-agent'], "content-type": "application/x-www-form-urlencoded"}, body: body2);
    // print(result);
    // return result !=null;
  }
}
