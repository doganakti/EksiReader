import 'dart:async';
import 'dart:convert';

import 'package:eksi_reader/helpers/eksi_client.dart';
import 'package:eksi_reader/models/configuration.dart';
import 'package:eksi_reader/models/entry.dart';
import 'package:eksi_reader/models/entry_content.dart';
import 'package:eksi_reader/models/section.dart';
import 'package:eksi_reader/models/topic.dart';
import 'package:eksi_reader/services/login_service.dart';
import 'package:flutter/services.dart' show rootBundle;

class EksiService {
  EksiClient _client = new EksiClient();

  EksiService() {}

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
    var document = await _client.get(path: path);
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
            var detailElements = element.getElementsByClassName("detail");
            var detail = "";
            if (detailElements.length > 0) {
              detail = detailElements[0].text;
              var index = text.lastIndexOf(detail);
              text = text.substring(0, index);
            }
            if (badgeElement != null) {
              badge = badgeElement.text;
              text = text.substring(0, text.length - badge.length).trim();

              if (detail != "") {}
            }
            var topic =
                new Topic(text, detail.length > 0 ? detail : null, url, badge);
            topicList.add(topic);
          }
        }
      } catch (error) {
        print(error);
      }
    }
    return topicList;
  }

  Future<List<Entry>> getEntryList(String path) async {
    path = '/3-mayis-2019-jti-sigara-zammi--6025436?a=popular';
    List<Entry> entryList = new List<Entry>();
    var document = await _client.get(path: path);
    var content = document.getElementById("content-body");
    var rawEntryList = content.getElementsByClassName('content');
    for (var rawEntry in rawEntryList) {
      var entryContentList = new List<EntryContent>();
      for (var child in rawEntry.nodes) {
        var entryContent = new EntryContent();
        if (child.toString() == "<html br>") {
          entryContent.br = true;
        } else if (child.attributes['class'] == 'b') {
          entryContent.innerLinkPath = child.attributes['href'];
          entryContent.innerLinkTitle = child.text;
        } else if (child.attributes['class'] == 'url') {
          entryContent.linkPath = child.attributes['href'];
          entryContent.linkTitle = child.text;
        } else if (child.attributes.length == 0) {
          entryContent.text = child.text.replaceAll("\n    ", "");
          entryContent.text = entryContent.text.replaceAll("\n   ", "");
          entryContent.text = entryContent.text.replaceAll("\n  ", "");
          entryContent.text = entryContent.text.replaceAll("\n ", "");
          entryContent.text = entryContent.text.replaceAll("\n", "");
        }
        // print(child.attributes['href']);
        // print(child.text);
        entryContentList.add(entryContent);
      }
      var entry = new Entry(entryContentList, null, null, null);
      entryList.add(entry);
    }
    for (var entry in entryList) {
      var res = entry.resultString();
      print(res);
    }
    return entryList;
  }

  Future<bool> login() async {
    return await _client.login();
  }
}
