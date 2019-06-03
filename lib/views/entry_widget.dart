import 'package:eksi_reader/models/entry.dart';
import 'package:eksi_reader/models/topic.dart';
import 'package:eksi_reader/services/eksi_service.dart';
import 'package:eksi_reader/views/author_widget.dart';
import 'package:eksi_reader/views/entries_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EntryWidget extends StatefulWidget {
  Entry entry;
  bool separator;
  EntryWidget({this.entry, this.separator: false});
  @override
  EntryWidgetState createState() => EntryWidgetState();
}

class EntryWidgetState extends State<EntryWidget> {
  @override
  Widget build(BuildContext context) {
    var bottomMenu = entryMenu();
    var entryWidget = Container(
        child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 0),
          child: Column(
            children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft,
                  child: widget.entry.resultRichText(Theme.of(context))),
              Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(widget.entry.date,
                            style: Theme.of(context).textTheme.display2),
                        InkWell(
                          child: Text(widget.entry.author.name,
                              style: Theme.of(context).textTheme.display1),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AuthorWidget(widget.entry.author)),
                            );
                          },
                        )
                      ])),
              bottomMenu
            ],
          ),
        )
      ],
    ));
    return entryWidget;
  }

  Widget entryMenu() {
    return Container(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Container(
                    transform: Matrix4.translationValues(-15, 0, 0),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.keyboard_arrow_up),
                            onPressed: () {
                              print('hey');
                            }),
                        IconButton(
                            icon: Icon(Icons.keyboard_arrow_down),
                            onPressed: () {
                              print('hey');
                            }),
                        IconButton(
                            icon: Icon(Icons.favorite_border, color: widget.entry.liked ? Theme.of(context).textTheme.display3.color : Theme.of(context).textTheme.display2.color),
                            iconSize: 16,
                            onPressed: () async {
                              print('hey');
                              if (widget.entry.liked) {
                                bool disLiked = await EksiService().dislike(widget.entry.id);
                                widget.entry.liked = !disLiked;
                                widget.entry.favCount = disLiked ? (int.parse(widget.entry.favCount) - 1).toString() : widget.entry.favCount;
                              } else {
                                bool liked = await EksiService().like(widget.entry.id);
                                widget.entry.liked = liked;
                                widget.entry.favCount = liked ? (int.parse(widget.entry.favCount) + 1).toString() : widget.entry.favCount;
                              }
                              setState(() {
                                
                              });
                            }),
                        Text(
                          widget.entry.favCount + ' favori',
                          style: Theme.of(context).textTheme.display2,
                        ),
                      ],
                    )),
              ],
            ),
          ),
          Container(
            transform: Matrix4.translationValues(14, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.open_in_browser),
                    onPressed: () {
                      print('hey');
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
