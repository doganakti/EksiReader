import 'package:eksi_reader/models/disambiguation.dart';
import 'package:eksi_reader/models/more.dart';
import 'package:eksi_reader/models/pager.dart';
import 'package:eksi_reader/models/topic.dart';

class Result<T> {
  List<T> itemList;
  T item;
  Pager pager;
  Topic topic;
  More more;
  Disambiguation disambiguation;

  Result({this.item, this.itemList, this.pager, this.topic});
}