import 'package:eksi_reader/models/settings_body.dart';

class SettingsSection {
  String title;
  String key;
  String selectedValue;
  bool newRoute;
  List<SettingsContent> contentList;

  SettingsSection({this.title, this.contentList, this.key, this.newRoute: false, this.selectedValue: ""});

  factory SettingsSection.fromJson(Map<String, dynamic> json) {
    List<SettingsContent> contents = [];
    if (json['new_route'] == null) {
      json['new_route'] = false;
    }
    if (json['contents'] != null) {
      var list = json['contents'] as List;
      contents = list.map((i) => SettingsContent.fromJson(i)).toList();
    }
    return SettingsSection(title: json['title'], key: json['key'], contentList: contents, newRoute: json['new_route'], selectedValue: json['selected_value']);
  }
}