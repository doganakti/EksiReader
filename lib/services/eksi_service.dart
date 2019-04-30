import 'dart:convert';

import 'package:eksi_reader/helpers/eksi_client.dart';
import 'package:eksi_reader/models/configuration.dart';
import 'package:eksi_reader/models/section.dart';
import 'package:eksi_reader/models/topic.dart';
import 'package:eksi_reader/services/login_service.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class EksiService {
  String _url = "https://eksisozluk.com";
  EksiClient _client = new EksiClient();
  LoginService _loginService = new LoginService();

  EksiService() {
    
  }

  Future<Configuration> getConfiguration() async {
    var json = await rootBundle.loadString('assets/configuration.json');
    Map<String, dynamic> configurationMap = await jsonDecode(json);
    var configuration = Configuration.fromJson(configurationMap);
    return configuration;
  }

  Future<List<Section>> getSectionList() async {
    var configuration = await getConfiguration();
    return configuration.sections;
  }

  Future<List<Topic>> getTopicList({String path: '/basliklar/gundem'}) async {
    List<Topic> topicList = new List<Topic>();
    var document = await _client.get(path);
    var content = document.querySelector("#content");
    var elementList = content.querySelectorAll('ul.topic-list > li');
    for (var element in elementList) {
      try {
        if (element.text != null) {
          var text = element.text.trim();
          var urlElement = element.querySelector('a');
          if (text != null && text.length > 0 && urlElement != null) {
            var url = urlElement.attributes['href'];
            var badgeElement = element.querySelector('small');
            var badge = '';
            if (badgeElement != null) {
              badge = badgeElement.text;
              text = text.substring(0, text.length - badge.length).trim();
            }
            var topic = new Topic(text, url, badge);
            topicList.add(topic);
          }
        }
      } catch (error) {
        print(error);
      }
    }
    return topicList;
  }

  Future<bool> login () async {
    return await _client.login();
  }
}
