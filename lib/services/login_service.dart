import 'dart:convert';
import 'dart:io';

import 'package:eksi_reader/helpers/eksi_client.dart';
import 'package:eksi_reader/models/user.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:dio/dio.dart';

class LoginService {
  String _url = "https://eksisozluk.com";
  EksiClient _client = new EksiClient();
  var _headers = {
    'user-agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36'
  };

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
    var document = await _client.getDocument(path: '/giris', cacheCookies: true);
    var content = document.querySelector("#content-body");
    var formContainer = content.querySelector(".form-container");
    var tokenInput = formContainer.querySelector("input");
    var token = tokenInput.attributes['value'];
    return token;
  }

  Future<bool> login() async {
    var user = await getUser();
    var token = await getToken();
    Map<String, String> body = {
      '__RequestVerificationToken': token,
      'ReturnUrl': 'https://eksisozluk.com/',
      'UserName': user.login,
      'Password': user.password,
      'RememberMe': 'true'
    };
    var contentType = ContentType.parse("application/x-www-form-urlencoded");
    var response = await Dio().post("https://eksisozluk.com/giris",
        data: body,
        options: new Options(headers: {
          'accept': "application/json",
          "content-type": "application/x-www-form-urlencoded",
          'user-agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36'
        }, contentType: contentType));
    print(response);
    return response != null;
  }
}
