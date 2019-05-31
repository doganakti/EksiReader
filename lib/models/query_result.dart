class QueryResult {
  List<String> titles;
  List<String> nicks;
  String query;

  QueryResult({this.titles, this.query, this.nicks});

  factory QueryResult.fromJson(Map<String, dynamic> json) {
    return QueryResult(
        titles: json['Titles'], nicks: json['Nicks'], query: json['Query']);
  }
}
