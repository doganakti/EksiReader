import 'package:eksi_reader/models/pager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PagerWidget extends StatefulWidget {
  Pager pager;
  Function(String) onPath;

  PagerWidget(this.pager, this.onPath);
  @override
  State<StatefulWidget> createState() => PagerWidgetState();
}

class PagerWidgetState extends State<PagerWidget> {
  PagerWidgetState();
  @override
  Widget build(BuildContext context) {
    print(widget.pager.page);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(" "),
          IconButton(
              icon: Icon(Icons.first_page), onPressed: () {}, iconSize: 40),
          IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              onPressed: () {},
              iconSize: 40),
          widget.pager.quickIndex != null
              ? FlatButton(
                  child: Text(widget.pager.quickIndexText),
                  textColor: Colors.white,
                  onPressed: () => { widget.onPath(widget.pager.quickIndex) }
                  )
              : Text(widget.pager.page.toString()),
          IconButton(
              icon: Icon(Icons.keyboard_arrow_right),
              onPressed: () {},
              iconSize: 40),
          IconButton(
              icon: Icon(Icons.last_page), onPressed: () {}, iconSize: 40),
          Text(" "),
        ],
      ),
    );
  }
}
