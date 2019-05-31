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
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Card(
        elevation: 0,
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
                color: Theme.of(context).brightness == Brightness.light
                    ? Theme.of(context).accentColor
                    : Colors.white,
                icon: Icon(Icons.first_page),
                onPressed: () {
                  widget.onPage(1);
                },
                iconSize: 30),
            IconButton(
                color: Theme.of(context).brightness == Brightness.light
                    ? Theme.of(context).accentColor
                    : Colors.white,
                icon: Icon(Icons.keyboard_arrow_left),
                onPressed: () {
                  if (widget.pager.page > 1) {
                    widget.onPage(widget.pager.page - 1);
                  }
                },
                iconSize: 30),
            Expanded(
              child: widget.pager?.quickIndexPath != null
                  ? InkWell(
                      child: SizedBox(
                        child: Center(
                          child: Text(widget.pager.quickIndexText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Theme.of(context).accentColor
                                    : Colors.white,
                              )),
                        ),
                      ),
                      onTap: () => {widget.onPath(widget.pager.quickIndexPath)})
                  : InkWell(
                      child: SizedBox(
                          child: Text(
                              widget.pager.page.toString() +
                                  ' / ' +
                                  widget.pager.pageCount.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Theme.of(context).accentColor
                                      : Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16))),
                      onTap: () => {print('hey')}),
            ),
            IconButton(
                color: Theme.of(context).brightness == Brightness.light
                    ? Theme.of(context).accentColor
                    : Colors.white,
                icon: Icon(Icons.keyboard_arrow_right),
                onPressed: () {
                  if (widget.pager?.page == null) {
                    widget.onPage(2);
                  } else if (widget.pager.page < widget.pager.pageCount) {
                    widget.onPage(widget.pager.page + 1);
                  }
                },
                iconSize: 30),
            IconButton(
                color: Theme.of(context).brightness == Brightness.light
                    ? Theme.of(context).accentColor
                    : Colors.white,
                icon: Icon(Icons.last_page),
                onPressed: () {
                  widget.onPage(widget.pager.pageCount);
                },
                iconSize: 30),
          ],
        ),
      ),
    );
  }
}
