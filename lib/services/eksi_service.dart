import 'dart:async';
import 'dart:convert';

import 'package:eksi_reader/helpers/eksi_client.dart';
import 'package:eksi_reader/models/author.dart';
import 'package:eksi_reader/models/configuration.dart';
import 'package:eksi_reader/models/entry.dart';
import 'package:eksi_reader/models/entry_content.dart';
import 'package:eksi_reader/models/pager.dart';
import 'package:eksi_reader/models/section.dart';
import 'package:eksi_reader/models/topic.dart';
import 'package:eksi_reader/results/result.dart';
import 'package:eksi_reader/services/login_service.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:html/dom.dart';

class EksiService {
  static final EksiService _instance = EksiService._internal();
  factory EksiService() => _instance;
  EksiClient _client = new EksiClient();

  EksiService._internal() {
    // init things inside this
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

  Future<Result> getTopicList({String path: '/basliklar/gundem'}) async {
    List<Topic> topicList = new List<Topic>();
    var document = await _client.get(path: path);
    var content = document.getElementById('content');
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
    var quickIndexContainer = content.getElementsByClassName('full-index-continue-link-container');
    var pagerContainer = content.getElementsByClassName('pager');
    Pager pager = getPager(quickIndexContainer, pagerContainer);
    var result = new Result<Topic>(item: null, itemList: topicList, pager: pager);
    return result;
  }

  Pager getPager(List<Element> quickIndexContainer, List<Element> pagerContainer) {
    var pager = new Pager();
    if(quickIndexContainer != null && quickIndexContainer.length > 0)
    {
      var quickIndexContent = quickIndexContainer[0].getElementsByTagName('a');
      if (quickIndexContent.length > 0)
      {
        var quickIndexPath = quickIndexContent[0].attributes['href'];
        var quickIndexTitle = quickIndexContent[0].text;
        pager.quickIndexPath = quickIndexPath;
        pager.quickIndexText = quickIndexTitle.replaceAll(' ...', '');
      }
    }
    else if (pagerContainer.length > 0)
    {
      pager.pageCount = int.parse(pagerContainer[0].attributes['data-pagecount']);
      pager.page = int.parse(pagerContainer[0].attributes['data-currentpage']);
    }
    return pager;
  }

  Future<Result<Entry>> getEntryList(String path) async {
    List<Entry> entryList = new List<Entry>();
    var document = await _client.get(path: path);
    var content = document.getElementById("content-body");
    var rawEntryList = content.getElementsByClassName('content');
    var dateList = document.getElementsByClassName("entry-date");
    var authorList = document.getElementsByClassName("entry-author");
    var entryItemList = document.getElementById("entry-item-list");
    var entryIdList = entryItemList.getElementsByTagName("li");
    for (int i = 0; i < rawEntryList.length; i++) {
      var rawEntry = rawEntryList[i];
      var date = dateList[i].text;
      var author = new Author(name: authorList[i].text, path: authorList[0].attributes['href']);
      var id = entryIdList[i].attributes['data-id'];
      var favCount = entryIdList[i].attributes['data-favorite-count'];
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
        entryContentList.add(entryContent);
      }
      var entry = new Entry(id, entryContentList, author, date, favCount);
      entryList.add(entry);
    }
    var pagerContainer = content.getElementsByClassName('pager');
    Pager pager = getPager(null, pagerContainer);
    var result = new Result<Entry>();
    result.itemList = entryList;
    result.pager = pager;
    return result;
  }

  Future<bool> login() async {
    return await _client.login();
  }
}
