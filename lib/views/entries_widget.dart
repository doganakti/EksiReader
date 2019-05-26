import 'dart:async';

import 'package:eksi_reader/models/author.dart';
import 'package:eksi_reader/models/eksi_uri.dart';
import 'package:eksi_reader/models/entry.dart';
import 'package:eksi_reader/models/topic.dart';
import 'package:eksi_reader/results/result.dart';
import 'package:eksi_reader/services/eksi_service.dart';
import 'package:eksi_reader/views/pager_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    _scrollController = ScrollController(initialScrollOffset: -30.0);

    loadData(this.topic.path);
  }

  Future<Null> loadData(String path) async {
    var result = await widget.service.getEntryList(path: path);
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
          style: TextStyle(
            fontSize: 16
          )
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
            )),
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
          style: TextStyle(
            fontSize: 16
          ),
        )),
        body: widget.data == null
            ? Container(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                          height: widget.loading ? 2.0 : 2.0,
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
                      Visibility(
                        visible: widget.loading,
                        child:  SizedBox(
                          height: widget.loading ? 2.0 : 2.0,
                          child: !widget.loading
                              ? Row()
                              : LinearProgressIndicator()),
                      ),
                     
                      Flexible(
                        child: listView,
                      ),
                      Container(
                        child: pagerWidget != null ? pagerWidget : Text(''),
                      ),
                    ])));
  }

  handleOnMore(path) async {
    widget.data = await widget.service.getEntryList(path: path);
    setState(() {});
  }

  handleOnPage(page) async {
    setState(() {
      widget.loading = true;
    });
    var path = EksiUri.getPathForPage(widget.topic.path, page);
    widget.data = await widget.service.getEntryList(path: path);
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
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          var entry = widget.data.itemList[index];
          entry.onUrl = handleOnUrl;
          var listTile = ListTile(
            contentPadding:
                EdgeInsets.only(top: 10, bottom: 0, left: 15, right: 15),
            subtitle: Container(
                padding: EdgeInsets.only(),
                child: Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: entry.resultRichText(Theme.of(context))),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(entry.date,
                                  style: Theme.of(context).textTheme.display2),
                              InkWell(
                                child: widget.topic.path.contains('/biri/')
                                    ? Text('')
                                    : Text(entry.author.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display1),
                                onTap: () {
                                  var topic = new Topic(entry.author.name, null,
                                      entry.author.path, null);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EntriesWidget(topic)),
                                  );
                                },
                              )
                            ])),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
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
