import 'package:eksi_reader/models/entry_content.dart';

class Entry {
  List<EntryContent> contentList;
  String author;
  String authorPath;
  String date;

  Entry(this.contentList, this.author, this.authorPath, this.date);

  String resultString() {
    String string = '';
    for(var content in contentList) {
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
}
