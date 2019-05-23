import 'dart:async';

import 'package:eksi_reader/models/eksi_uri.dart';
import 'package:eksi_reader/models/entry.dart';
import 'package:eksi_reader/models/topic.dart';
import 'package:eksi_reader/results/result.dart';
import 'package:eksi_reader/services/eksi_service.dart';
import 'package:eksi_reader/views/pager_widget.dart';
import 'package:flutter/material.dart';

class EntriesWidget extends StatefulWidget {
  Topic topic;
  var service = new EksiService();
  EntriesWidget(this.topic);
  Result<Entry> data;
  bool loading = false;
  @override
  State createState() => new EntriesWidgetState(topic);
}

class EntriesWidgetState extends State<EntriesWidget>
    with SingleTickerProviderStateMixin {
  Topic topic;
  EntriesWidgetState(this.topic);

  @override
  void initState() {
    super.initState();
    loadData(this.topic.path);
  }

  Future<Null> loadData(String path) async {
    var result = await widget.service.getEntryList(path);
    setState(() {
      widget.data = result;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data?.itemList == null) {
      return new Scaffold(
        appBar: AppBar(
          title: Text('EksiReader'),
          bottom: PreferredSize(
            child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 15.0, 10.0),
                  child: Text(
                    topic.title,
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                )),
            preferredSize: Size(0.0, 48.0),
          ),
        ),
        body: SizedBox(
            height: widget.loading ? 1.0 : 1.0,
            child: new LinearProgressIndicator(
              backgroundColor: widget.loading
                  ? Theme.of(context).accentColor
                  : Theme.of(context).primaryColor,
            )),
      );
    }
    var listView = getListView();
    var pagerWidget =
        PagerWidget(widget.data.pager, handleOnMore, handleOnPage);
    return Scaffold(
        appBar: AppBar(
          title: Text('EksiReader'),
          bottom: PreferredSize(
            child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 15.0, 10.0),
                  child: Text(
                    topic.title,
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                )),
            preferredSize: Size(0.0, 48.0),
          ),
        ),
        body: Container(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      height: widget.loading ? 1.0 : 1.0,
                      child: !widget.loading ? Row() : new LinearProgressIndicator(
                        )),
                  Expanded(
                    child: SizedBox(child: listView),
                  ),
                  pagerWidget,
                  Row()
                ])));
  }

  handleOnMore(path) async {
    widget.data = await widget.service.getEntryList(path);
    setState(() {});
  }
  Future sleep1() {
    return new Future.delayed(const Duration(seconds: 1), () => "1");
  }
  handleOnPage(page) async {
    
    
    setState(() {
      widget.loading = true;
    });
    await new Future.delayed(const Duration(seconds: 2));
    var path = EksiUri.getPathForPage(widget.topic.path, page);
    widget.data = await widget.service.getEntryList(path);
    
    setState(() {
      widget.loading = false;
    });
  }

  ListView getListView() {
    var listView = ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Colors.black45,
            ),
        itemCount: widget.data.itemList.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var entry = widget.data.itemList[index];
          var listTile = ListTile(
            contentPadding:
                EdgeInsets.only(top: 0, bottom: 0, left: 15, right: 0),
            title: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(entry.author.name,
                                style: TextStyle(
                                    color: Colors.green[400],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                            Text(entry.date,
                                style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100)),
                          ]),
                    ),
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.more_horiz),
                        onPressed: () {
                          print('hey');
                        },
                      ),
                    )
                  ],
                )),
            subtitle: Container(
                padding: EdgeInsets.only(right: 20),
                child: Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(entry.resultString(),
                            style: TextStyle(
                                color: Colors.grey[100], fontSize: 15),
                            textAlign: TextAlign.left)),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                    transform:
                                        Matrix4.translationValues(-15, 0, 0),
                                    child: Row(
                                      children: <Widget>[
                                        IconButton(
                                            icon: Icon(Icons.keyboard_arrow_up),
                                            onPressed: () {
                                              print('hey');
                                            }),
                                        IconButton(
                                            icon:
                                                Icon(Icons.keyboard_arrow_down),
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
                                          entry.favCount + ' favori',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[400]),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            transform: Matrix4.translationValues(20, 0, 0),
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
                    )
                  ],
                )),
          );
          var listTileContainer = Container(
            //color: index % 2 == 1 ? Colors.black12 :Colors.black12,
            child: listTile,
          );
          return listTileContainer;
        });
    return listView;
  }
}

class SliverMultilineAppBar extends StatelessWidget {
  final String title;
  final Widget leading;
  final List<Widget> actions;

  SliverMultilineAppBar({this.title, this.leading, this.actions});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    double availableWidth = mediaQuery.size.width - 150;
    if (actions != null) {
      availableWidth -= 32 * actions.length;
    }
    if (leading != null) {
      availableWidth -= 32;
    }
    return SliverAppBar(
      expandedHeight: 160,
      leading: leading,
      actions: actions,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(top: 20, bottom: 10),
        background: Image.network(
          "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
          fit: BoxFit.cover,
        ),
        title: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: availableWidth,
          ),
          child: Text(
            title,
            textScaleFactor: 1,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
