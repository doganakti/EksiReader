import 'dart:async';
import 'dart:convert';

import 'package:eksi_reader/helpers/eksi_client.dart';
import 'package:eksi_reader/models/author.dart';
import 'package:eksi_reader/models/configuration.dart';
import 'package:eksi_reader/models/eksi_uri.dart';
import 'package:eksi_reader/models/entry.dart';
import 'package:eksi_reader/models/entry_content.dart';
import 'package:eksi_reader/models/pager.dart';
import 'package:eksi_reader/models/query_result.dart';
import 'package:eksi_reader/models/section.dart';
import 'package:eksi_reader/models/settings_section.dart';
import 'package:eksi_reader/models/topic.dart';
import 'package:eksi_reader/models/user.dart';
import 'package:eksi_reader/results/result.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_keychain/flutter_keychain.dart';
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

  Future<List<SettingsSection>> getSettingsSectionList() async {
    var configuration = await getConfiguration();
    for (var section in configuration.settingsSections) {
      var value = await FlutterKeychain.get(key: section.key);
      if (value == null) {
        await FlutterKeychain.put(
            key: section.key, value: section.selectedValue);
      } else {
        section.selectedValue = value;
      }
    }
    return configuration.settingsSections;
  }

  Future<Result> getTopicList({String path = '/basliklar/gundem'}) async {
    List<Topic> topicList = new List<Topic>();
    var document = await _client.getDocument(path: path);
    var content = document.getElementById('content');
    var elementList = content.querySelectorAll('ul.topic-list > li');
    for (var element in elementList) {
      try {
        if (element.text != null) {
          var text = element.text.trim();
          var urlElement = element.querySelector('a');
          if (text != null && text.isNotEmpty && urlElement != null) {
            var url = urlElement.attributes['href'];
            var badgeElement = element.querySelector('small');
            var badge = '';
            var detailElements = element.getElementsByClassName("detail");
            var detail = "";
            if (detailElements.isNotEmpty) {
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
                new Topic(text, detail.isNotEmpty ? detail : null, url, badge);
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

  Pager getPager(
      List<Element> quickIndexContainer, List<Element> pagerContainer) {
    var pager = new Pager();
    if (quickIndexContainer != null && quickIndexContainer.isNotEmpty) {
      var quickIndexContent = quickIndexContainer[0].getElementsByTagName('a');
      if (quickIndexContent.isNotEmpty) {
        var quickIndexPath = quickIndexContent[0].attributes['href'];
        var quickIndexTitle = quickIndexContent[0].text;
        pager.quickIndexPath = quickIndexPath;
        pager.quickIndexText = quickIndexTitle.replaceAll(' ...', '');
      }
    } else if (pagerContainer.isNotEmpty) {
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
      int authorPage,
      Pager pager}) async {
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

      if (path.contains('nick=')) {
        subContent = true;
        author = EksiUri.getAuthorFromPath(path);
      }

      var document = await _client.getDocument(path: path, subContent: subContent);
      var topic = document.getElementById('topic');
      var topicContainer = topic.getElementsByTagName('h1')[0];
      var topicModel = new Topic(topicContainer.attributes['data-title'], null,
          topicContainer.getElementsByTagName('a')[0].attributes['href'], null);
      topicModel.path = EksiUri.resetPath(topicModel.path, path);
      var topicItemList = topic.getElementsByClassName('topic-item');
      var entryList = new List<Entry>();
      if (author != null && subContent) {
        try {
          var entryCount = document.getElementsByTagName('h1')[0].getElementsByTagName('small')[0].text.trim().replaceAll('(', '').replaceAll(')', '');
          var remaining = int.parse(entryCount) % 10 > 0 ? 1 : 0;
          int division = int.parse(entryCount) ~/ 10;
          var pageCount = division + remaining;
          if (authorPage == null) {
            authorPage = 1;
          }
          var page = EksiUri.getPageFromPath(path);
          result.pager = Pager(page: page, pageCount: pageCount);
        } catch (e) {

          pager.page = EksiUri.getPageFromPath(path);;
          result.pager = pager;
        }

      }
      if (topicItemList.isNotEmpty) {
        for (var topicItem in topicItemList) {
          var h1 = topicItem.getElementsByTagName('h1')[0];
          var entryItemList =
              topicItem.querySelectorAll('#entry-item-list > li');
          if (entryItemList.isNotEmpty) {
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
        if (entryItemList.isNotEmpty) {
          for (var entryItem in entryItemList) {
            var entry = getEntry(entryItem, null);
            entryList.add(entry);
          }
        }
      }
      result.itemList = entryList;
      result.topic = topicModel;
      if (result.pager == null) {
        var pagerContainer = document.getElementsByClassName('pager');
        result.pager = getPager(null, pagerContainer);
      }
    } catch (e) {
      print(e);
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

  Future<Result<Section>> getAuthorSections({Author author}) async {
    List<Section> sectionList = new List<Section>();
    try {
      var document = await _client.getDocument(path: author.path);
      var content = document.getElementById("profile-stats-section-nav");
      var aList = content.getElementsByTagName('a');
      for (var a in aList) {
        var section =
            new Section(title: a.text.trim(), path: a.attributes['href']);
        if (!section.title.contains('istatistikler') &&
            !section.path.contains('el-emegi-goz-nuru') &&
            !section.path.contains('favori-yazarlari') &&
            !section.path.contains('katkida-bulundugu-kanallar') &&
            !section.path.contains('ukteleri') &&
            !section.title.contains('sorunsalları') &&
            !section.title.contains('sorunsal yanıtları')) {
          sectionList.add(section);
        }
      }
    } catch (e) {
      print(e);
    }
    var result = new Result<Section>(itemList: sectionList);
    return result;
  }

  Future<Result<Entry>> getAuthorEntryList(
      {Author author, Section section, int page, Pager pager}) async {
    var path = EksiUri.getAuthorSectionPath(author, section, page);
    var result = await getEntryList(path: path, subContent: true, authorPage: page, pager:pager);
    return result;
  }
  
  Future<User> setCredentials(String userName, String password) async {
    await FlutterKeychain.put(key: 'username', value: userName);
    await FlutterKeychain.put(key: 'password', value: password);
    return User(login: userName, password: password);
  }

  Future<Author> login() async {
    await _client.login();
    return await getAuthor();
  }

  Future<bool> logout() async {
    return await _client.logout();
  }

  Future<User> getUser() async {
    return await _client.getUser();
  }

  Future<Author> getAuthorDetail({Author author}) async {
    if (author == null) {
      author = await getAuthor();
    }
    if (author != null) {
      var document = await _client.getDocument(path: '/biri/${author.name}');
      var userBadgesContainer = document.getElementById('user-badges');
      var badgeElements = userBadgesContainer.getElementsByTagName('li');
      author.badges = List<String>();
      for(var badgeElement in badgeElements) {
        author.badges.add(badgeElement.text.trim());
      }

      var userEntryStatsContainer = document.getElementById('user-entry-stats');
      var statElements = userEntryStatsContainer.getElementsByTagName('li');
      var statString = '';
      for(var stat in statElements) {
        statString = statString + stat.text.trim() + ' · ';
      }
      statString = statString.replaceRange(statString.length - 2, statString.length, '');
      author.stats = statString;
      author.path = '/biri/${author.name}';
    }
    return author;
  }

  Future<List<Topic>> autoComplete(String input) async {
    try {
      var data = await _client.getResult(path: '/autocomplete/query?q=$input', subContent: true);
      var topics = new List<Topic>();
      for(var item in data['Titles']) {
        var topic = new Topic(item, null, '/?q=$item', null);
        topics.add(topic);
      }
      for(var item in data['Nicks']) {
        var topic = new Topic('@$item', null, '/biri/$item', null);
        topics.add(topic);
      }
      return topics;  
    } catch (e) {
      print(e);
      return null;
    }
  }
  
  Future<Author> getAuthor() async {
    try {
      var document = await _client.getDocument(path: '/');
      var scripts = document.getElementsByTagName('script');
      var dataLayer = scripts.firstWhere((o) => o.text.contains('dataLayer'));
      var data = dataLayer.text.replaceAll('dataLayer = [', '').replaceAll('];', '').replaceAll("'", '"').replaceAll(',\n  ', ',').replaceAll('"",}', '""}').trim();
      Map<String, dynamic> valueMap = json.decode(data);
      var login = valueMap['eauthor'];
      return login != '' ? Author(name: login) : null;
    } catch (e) {
      return null;
    }
  }
}
