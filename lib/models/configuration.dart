import 'package:eksi_reader/models/section.dart';
import 'package:eksi_reader/models/settings_section.dart';

class Configuration {
  List<Section> sections;
  List<SettingsSection> settingsSections;

  Configuration({this.sections, this.settingsSections});

  factory Configuration.fromJson(Map<String, dynamic> json) {
    var list = json['sections'] as List;
    var settingsSections = json['settings_sections'] as List;
    List<Section> sectionList = list.map((i) => Section.fromJson(i)).toList();
    List<SettingsSection> settingsSectionlist = settingsSections.map((i) => SettingsSection.fromJson(i)).toList();
    return Configuration(
      sections: sectionList,
      settingsSections: settingsSectionlist
    );
  }
}
