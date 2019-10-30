import 'package:eksi_reader/models/author.dart';
import 'package:eksi_reader/models/entry_content.dart';
import 'package:eksi_reader/models/more.dart';
import 'package:eksi_reader/models/topic.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Entry {
  String id;
  List<EntryContent> contentList;
  Author author;
  String date;
  String favCount;
  Function(String, String, String) onUrl;
  Topic topic;
  bool liked;
  ThemeData theme;

  Entry(this.id, this.contentList, this.author, this.date, this.favCount,
      this.topic);

  String resultString() {
    String string = '';
    for (var content in contentList) {
      if (content.text != null) {
        string = string + content.text;
      } else if (content.br == true) {
        string = string + '\n';
      } else if (content.linkPath != null) {
        string = string + '[link]' + content.linkTitle;
      } else if (content.innerLinkPath != null) {
        string = string + '[innerLink]' + content.innerLinkTitle;
      }
    }
    return string;
  }

  RichText _resultRichText;
  RichText resultRichText(ThemeData theme) {
    if (_resultRichText == null) {
      var textSpanList = new List<TextSpan>();
      if (topic != null) {
        var span = TextSpan(
            text: topic.title + '\n\n',
            style: theme.textTheme.display3,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                print(topic.path);
                onUrl(null, topic.path, topic.title);
              });
        textSpanList.add(span);
      }
      for (var content in contentList) {
        if (content.text != null) {
          var span = TextSpan(text: content.text, style: theme.textTheme.body1);
          textSpanList.add(span);
        } else if (content.br == true) {
          var span = TextSpan(text: '\n', style: theme.textTheme.body1);
          textSpanList.add(span);
        } else if (content.linkPath != null) {
          var span = TextSpan(
              text: content.linkTitle + '~',
              style: theme.textTheme.display3,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  print(content.linkPath);
                  onUrl(content.linkPath, null, content.linkTitle);
                });
          textSpanList.add(span);
        } else if (content.innerLinkPath != null) {
          var span = TextSpan(
              text: content.innerLinkTitle,
              style: theme.textTheme.display3,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  print(content.innerLinkPath);
                  onUrl(null, content.innerLinkPath, content.innerLinkTitle);
                });
          textSpanList.add(span);
        }
      }
      _resultRichText = RichText(
        text: TextSpan(children: textSpanList),
      );
    }
    return _resultRichText;
  }
}
