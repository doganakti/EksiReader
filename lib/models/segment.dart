
class Segment {
  String title;
  String path;

  Segment({this.title, this.path});

  factory Segment.fromJson(Map<String, dynamic> json) {
    return Segment(title: json['title'], path: json['path']);
  }
}