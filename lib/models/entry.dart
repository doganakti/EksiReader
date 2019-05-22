import 'package:eksi_reader/models/author.dart';
import 'package:eksi_reader/models/entry_content.dart';

class Entry {
  String id;
  List<EntryContent> contentList;
  Author author;
  String date;
  String favCount;

  Entry(this.id, this.contentList, this.author, this.date, this.favCount);

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
