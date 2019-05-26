import 'package:eksi_reader/models/pager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PagerWidget extends StatefulWidget {
  Pager pager;
  Function(String) onPath;
  Function(int) onPage;

  PagerWidget(this.pager, this.onPath, this.onPage);
  @override
  State<StatefulWidget> createState() => PagerWidgetState();
}

class PagerWidgetState extends State<PagerWidget> {
  PagerWidgetState();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
              color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).primaryColor : Colors.white,
              icon: Icon(Icons.first_page),
              onPressed: () {
                widget.onPage(1);
              },
              iconSize: 40),
          IconButton(
              color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).primaryColor : Colors.white,
              icon: Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                if (widget.pager.page > 1) {
                  widget.onPage(widget.pager.page - 1);
                }
              },
              iconSize: 40),
          widget.pager?.quickIndexPath != null
              ? InkWell(
                  child: SizedBox(
                    width: 100,
                    child: Center(
                      child: Text(widget.pager.quickIndexText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).primaryColor : Colors.white,
                          )),
                    ),
                  ),
                  onTap: () => {widget.onPath(widget.pager.quickIndexPath)})
              : SizedBox(
                  width: 134,
                  child: Center(
                      child: Text(widget.pager.page.toString() +
                          ' / ' +
                          widget.pager.pageCount.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).primaryColor : Colors.white,
                          ))),
                ),
          IconButton(
              color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).primaryColor : Colors.white,
              icon: Icon(Icons.keyboard_arrow_right),
              onPressed: () {
                if (widget.pager?.page == null) {
                  widget.onPage(2);
                } else if (widget.pager.page < widget.pager.pageCount) {
                  widget.onPage(widget.pager.page + 1);
                }
              },
              iconSize: 40),
          IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.last_page),
              onPressed: () {
                widget.onPage(widget.pager.pageCount);
              },
              iconSize: 40),
        ],
      ),
    );
  }
}
