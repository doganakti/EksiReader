import 'package:eksi_reader/models/pager.dart';
import 'package:eksi_reader/models/topic.dart';

class Result<T> {
  List<T> itemList;
  T item;
  Pager pager;
  Topic topic;

  Result({this.item, this.itemList, this.pager, this.topic});
}