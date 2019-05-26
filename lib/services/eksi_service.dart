import 'dart:async';
import 'dart:convert';

import 'package:eksi_reader/helpers/eksi_client.dart';
import 'package:eksi_reader/models/author.dart';
import 'package:eksi_reader/models/configuration.dart';
import 'package:eksi_reader/models/eksi_uri.dart';
import 'package:eksi_reader/models/entry.dart';
import 'package:eksi_reader/models/entry_content.dart';
import 'package:eksi_reader/models/pager.dart';
import 'package:eksi_reader/models/section.dart';
import 'package:eksi_reader/models/topic.dart';
import 'package:eksi_reader/results/result.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:html/dom.dart';

class EksiService {
  static final EksiService _instance = EksiService._internal();
  factory EksiService() => _instance;
  EksiClient _client = new EksiClient();
  List<Section> authorSectionList = [
    new Section(title: 'Entriler', authorSection: 'son-entryleri'),
    new Section(title: 'Favoriler', authorSection: 'favori-entryleri'),
    new Section(
        title: 'Favorilenenler', authorSection: 'en-cok-favorilenen-entryleri'),
    new Section(title: 'Oylananlar', authorSection: 'son-oylananlari')
  ];

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
    var quickIndexContainer =
        content.getElementsByClassName('full-index-continue-link-container');
    var pagerContainer = content.getElementsByClassName('pager');
    Pager pager = getPager(quickIndexContainer, pagerContainer);
    var result =
        new Result<Topic>(item: null, itemList: topicList, pager: pager);
    return result;
  }

  Pager getPager(List<Element> quickIndexContainer, List<Element> pagerContainer) {
    var pager = new Pager();
    if (quickIndexContainer != null && quickIndexContainer.length > 0) {
      var quickIndexContent = quickIndexContainer[0].getElementsByTagName('a');
      if (quickIndexContent.length > 0) {
        var quickIndexPath = quickIndexContent[0].attributes['href'];
        var quickIndexTitle = quickIndexContent[0].text;
        pager.quickIndexPath = quickIndexPath;
        pager.quickIndexText = quickIndexTitle.replaceAll(' ...', '');
      }
    } else if (pagerContainer.length > 0) {
      pager.pageCount =
          int.parse(pagerContainer[0].attributes['data-pagecount']);
      pager.page = int.parse(pagerContainer[0].attributes['data-currentpage']);
    }
    return pager;
  }

  Future<Result<Entry>> getEntryList(
      {String path,
      bool subContent,
      Author author,
      Section authorSection,
      int authorPage}) async {
    var result = new Result<Entry>();
    try {
      if (path.contains('/biri/') && author == null) {
        authorPage = EksiUri.getPageFromPath(path) != 0
            ? EksiUri.getPageFromPath(path)
            : null;
        path = EksiUri.removePageFromPath(path);
        var name = path.split('/').last;
        author = new Author(name: name, path: '/biri/$name');
      }
      if (author != null) {
        subContent = true;
        path = EksiUri.getAuthorSectionPath(author, authorSection, authorPage);
      }
      var document = await _client.get(path: path, subContent: subContent);
      var topic = document.getElementById('topic');
      var topicItemList = topic.getElementsByClassName('topic-item');
      var entryList = new List<Entry>();
      if (topicItemList.length > 0) {
        for (var topicItem in topicItemList) {
          var h1 = topicItem.getElementsByTagName('h1')[0];
          var entryItemList =
              topicItem.querySelectorAll('#entry-item-list > li');
          if (entryItemList.length > 0) {
            var topicTitle = h1.attributes['data-title'];
            var topicPath = h1.getElementsByTagName('a')[0].attributes['href'];
            var topic = new Topic(topicTitle, null, topicPath, null);
            for (var entryItem in entryItemList) {
              var entry = getEntry(entryItem, topic);
              entryList.add(entry);
            }
          }
        }
      } else {
        var entryItemList = topic.querySelectorAll(
            '#entry-item-list > li'); //topic.getElementsByTagName('ul')[0].getElementsByTagName('li');
        if (entryItemList.length > 0) {
          for (var entryItem in entryItemList) {
            var entry = getEntry(entryItem, null);
            entryList.add(entry);
          }
        }
      }
      result.itemList = entryList;
      var pagerContainer = document.getElementsByClassName('pager');
      result.pager = getPager(null, pagerContainer);
    } catch (e) {
      result.itemList = new List<Entry>();
    }
    return result;
  }

  Entry getEntry(Element entryItem, Topic topic) {
    var id = entryItem.attributes['data-id'];
    var authorId = entryItem.attributes['data-author-id'];
    var favCount = entryItem.attributes['data-favorite-count'];
    var entryContent = entryItem.getElementsByClassName('content')[0];
    var contentList = getEntryContentList(entryContent);
    var footer = entryItem.getElementsByTagName('footer')[0];
    var info = footer.getElementsByClassName('info')[0];
    var date = info.getElementsByClassName('entry-date permalink')[0].text;
    var authorElement = info.getElementsByClassName('entry-author')[0];
    var author = new Author(
        id: authorId,
        name: authorElement.text,
        path: authorElement.attributes['href']);
    var entry = new Entry(id, contentList, author, date, favCount, topic);
    return entry;
  }

  List<EntryContent> getEntryContentList(Element entryItem) {
    var contentList = new List<EntryContent>();
    for (var child in entryItem.nodes) {
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
        if (entryItem.nodes.indexOf(child) == 0) {
          child.text = child.text.trimLeft();
        }
        entryContent.text = child.text;
      }
      contentList.add(entryContent);
    }
    return contentList;
  }

  Future<Result<Section>> getAuthorSections(Author author) async {
    List<Section> sectionList = new List<Section>();
    try {
      var document = await _client.get(path: author.path);
      var content = document.getElementById("profile-stats-section-nav");
      var aList = content.getElementsByTagName('a');
      for (var a in aList) {
        var section = new Section(title: a.text, path: a.attributes['href']);
        sectionList.add(section);
      }
    } catch (e) {
      print(e);
    }
    var result = new Result<Section>(itemList: sectionList);
    return result;
  }

  Future<Result<Entry>> getAuthorEntryList(
      Author author, Section section, int page) async {
    var path = EksiUri.getAuthorSectionPath(author, section, page);
    var result = await getEntryList(path: path, subContent: true);
    return result;
  }

  Future<bool> login() async {
    return await _client.login();
  }
}
