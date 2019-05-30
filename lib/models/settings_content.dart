class SettingsContent {
  String title;
  String key;
  String value;

  SettingsContent({this.title, this.key, this.value});

  factory SettingsContent.fromJson(Map<String, dynamic> json) {
    return SettingsContent(title: json['title'], key: json['key'], value: json['value']);
  }
}