import 'package:eksi_reader/models/section.dart';

class Configuration {
  List<Section> sections;
  Configuration({this.sections});

  factory Configuration.fromJson(Map<String, dynamic> json) {
    var list = json['sections'] as List;
    List<Section> sectionList = list.map((i) => Section.fromJson(i)).toList();
    return Configuration(
      sections: sectionList
    );
  }
}
