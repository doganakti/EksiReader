import 'package:eksi_reader/models/pager.dart';

class Result<T> {
  List<T> itemList;
  T item;
  Pager pager;

  Result({this.item, this.itemList, this.pager});
}