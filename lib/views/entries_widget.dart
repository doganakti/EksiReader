import 'dart:async';

import 'package:eksi_reader/models/eksi_uri.dart';
import 'package:eksi_reader/models/entry.dart';
import 'package:eksi_reader/models/topic.dart';
import 'package:eksi_reader/results/result.dart';
import 'package:eksi_reader/services/eksi_service.dart';
import 'package:eksi_reader/views/pager_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:boxicons_flutter/boxicons_flutter.dart';

class EntriesWidget extends StatefulWidget {
  Topic topic;
  var service = EksiService();
  EntriesWidget(this.topic);
  Result<Entry> data;
  bool loading = true;
  bool noContent = false;
  @override
  State createState() => EntriesWidgetState(topic);
}

class EntriesWidgetState extends State<EntriesWidget>
    with SingleTickerProviderStateMixin {
  Topic topic;
  EntriesWidgetState(this.topic);
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    loadData(this.topic.path);
  }

  Future<Null> loadData(String path) async {
    var result = await widget.service.getEntryList(path);
    setState(() {
      widget.data = result;
      widget.loading = false;
      widget.noContent = widget.data?.itemList?.length == 0;
    });
    return null;
  }

  @override
  void didUpdateWidget(EntriesWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.data = oldWidget.data;
    widget.loading = false;
    // here you can check value of old widget status and compare vs current one
  }

  @override
  Widget build(BuildContext context) {
    if (widget.noContent) {
      return Scaffold(
        appBar: AppBar(
            title: Text(
          topic.title,
          maxLines: 2,
          style: Theme.of(context).textTheme.title,
        )),
        body: Align(
            alignment: Alignment.center,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Icon(FontAwesomeIcons.exclamation, size: 30),
                ),
                Text("Yok böyle bişi")
              ],
            ),
            ) ),
      );
    }
    var listView = widget.data?.itemList != null ? getListView() : null;
    var pagerWidget = widget.data?.itemList != null
        ? PagerWidget(widget.data.pager, handleOnMore, handleOnPage)
        : null;
    return Scaffold(
        appBar: AppBar(
            title: Text(
          topic.title,
          maxLines: 2,
          style: Theme.of(context).textTheme.title,
        )),
        body: widget.data == null
            ? Container(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                          height: widget.loading ? 1.0 : 1.0,
                          child: !widget.loading
                              ? Row()
                              : LinearProgressIndicator()),
                    ]))
            : Container(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          height: widget.loading ? 1.0 : 1.0,
                          child: !widget.loading
                              ? Row()
                              : LinearProgressIndicator()),
                      Flexible(
                        child: listView,
                      ),
                      Container(
                        child: pagerWidget != null ? pagerWidget : Text(''),
                      ),
                    ])));
  }

  handleOnMore(path) async {
    widget.data = await widget.service.getEntryList(path);
    setState(() {});
  }

  handleOnPage(page) async {
    setState(() {
      widget.loading = true;
    });
    var path = EksiUri.getPathForPage(widget.topic.path, page);
    widget.data = await widget.service.getEntryList(path);
    setState(() {
      widget.loading = false;
    });
    scrollToTop();
  }

  handleOnUrl(url, innerUrl, title) async {
    if (url != null) {
      await launch(url);
    } else if (innerUrl != null) {
      print('load $innerUrl');
      var entryTopic = Topic(title, null, innerUrl, '0');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EntriesWidget(entryTopic)),
      );
    }
  }

  scrollToTop() {
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
    setState(() => {});
  }

  ListView getListView() {
    var listView = ListView.separated(
        controller: _scrollController,
        separatorBuilder: (context, index) => Divider(
              color: Colors.black45,
            ),
        itemCount: widget.data.itemList.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var entry = widget.data.itemList[index];
          entry.onUrl = handleOnUrl;
          var listTile = ListTile(
            contentPadding:
                EdgeInsets.only(top: 10, bottom: 0, left: 15, right: 15),
            // title: Container(
            //     padding: EdgeInsets.only(bottom: 10),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: <Widget>[
            //         Container(
            //           child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: <Widget>[
            //                 Text(entry.author.name,
            //                     style: Theme.of(context).textTheme.display1),
            //                 Text(entry.date,
            //                     style: Theme.of(context).textTheme.display2),
            //               ]),
            //         ),
            //         Container(
            //           child: IconButton(
            //             icon: Icon(Icons.more_horiz),
            //             onPressed: () {
            //               print('hey');
            //             },
            //           ),
            //         )
            //       ],
            //     )),
            subtitle: Container(
                padding: EdgeInsets.only(),
                child: Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: entry.resultRichText(Theme.of(context))),
                    Container(
                        padding: EdgeInsets.only(bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(entry.date,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display2),
                                        Text(entry.author.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display1),
                                      ]),
                                ))
                          ],
                        )),
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .display2,
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
