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
    
    return  Container(
      
      child: Material(
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          
          IconButton(
              icon: Icon(Icons.first_page),
              onPressed: () {
                widget.onPage(1);
              },
              iconSize: 40),
          IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                if (widget.pager.page > 1) {
                  widget.onPage(widget.pager.page - 1);
                }
              },
              iconSize: 40),
          widget.pager?.quickIndexPath != null
              ? FlatButton(
                  child: SizedBox(
                    width: 100,
                    child: Center(
                      child: Text(widget.pager.quickIndexText,
                          textAlign: TextAlign.center),
                    ),
                  ),
                  textColor: Colors.white,
                  onPressed: () => {widget.onPath(widget.pager.quickIndexPath)})
              : SizedBox(
                  width: 134,
                  child: Center(
                    child: Text(widget.pager.page.toString() +
                        ' / ' +
                        widget.pager.pageCount.toString()),
                  ),
                ),
          IconButton(
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
              icon: Icon(Icons.last_page), onPressed: () {
                widget.onPage(widget.pager.pageCount);
              }, iconSize: 40),
          
        ],
      ),
      ) ,
    );
  }
}
