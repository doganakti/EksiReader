import 'package:eksi_reader/models/segment.dart';
import 'package:eksi_reader/models/topic.dart';

class Section {
  String title;
  String path;
  bool login;
  List<Segment> segments;
  List<Topic> topicList;

  Section({this.title, this.path, this.login, this.segments});

  factory Section.fromJson(Map<String, dynamic> json) {
    List<Segment> segmentList = null;
    if (json['segments'] != null) {
      var list = json['segments'] as List;
      segmentList = list.map((i) => Segment.fromJson(i)).toList();
    }
    return Section(
        title: json['title'],
        path: json['path'],
        login: json['login'],
        segments: segmentList);
  }
}
