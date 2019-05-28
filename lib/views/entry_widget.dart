import 'package:eksi_reader/models/entry.dart';
import 'package:eksi_reader/models/topic.dart';
import 'package:eksi_reader/views/entries_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EntryWidget extends StatefulWidget {
  Entry entry;
  bool separator;
  EntryWidget({this.entry, this.separator:false});
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
          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Column(
          children: <Widget>[
            Align(
                alignment: Alignment.centerLeft,
                child: widget.entry.resultRichText(Theme.of(context))),
            Align(
                alignment: Alignment.centerRight,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(widget.entry.date,
                          style: Theme.of(context).textTheme.display2),
                      InkWell(
                        child: Text(widget.entry.author.name,
                            style: Theme.of(context).textTheme.display1),
                        onTap: () {
                          var topic = new Topic(widget.entry.author.name, null,
                              widget.entry.author.path, null);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EntriesWidget(topic)),
                          );
                        },
                      )
                    ])),
            bottomMenu
          ],
        ),
        ),
        Container(
          height: 1.0,
          color: widget.separator ? Colors.black12 : Colors.transparent,
        )
      ],
    ));
    return entryWidget;
  }

  Widget entryMenu() {
    return Container(
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
                            icon: Icon(Icons.favorite_border),
                            iconSize: 16,
                            onPressed: () {
                              print('hey');
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
