import 'package:eksi_reader/models/eksi_uri.dart';
import 'package:eksi_reader/models/pager.dart';
import 'package:eksi_reader/models/section.dart';
import 'package:eksi_reader/models/topic.dart';
import 'package:eksi_reader/services/eksi_service.dart';
import 'package:eksi_reader/views/entries_widget.dart';
import 'package:eksi_reader/views/loading_widget.dart';
import 'package:eksi_reader/views/pager_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'empty_widget.dart';

class TopicListWidget extends StatefulWidget {
  String path;
  Pager pager;
  List<Topic> topicList;

  TopicListWidget({this.path});

  @override
  TopicListWidgetState createState() => TopicListWidgetState();
}

class TopicListWidgetState extends State<TopicListWidget> {
  EksiService service = EksiService();
  ScrollController scrollController = ScrollController();
  bool loading = false;
  bool noContent = false;
  bool refreshing = false;

  @override
  void initState() {
    super.initState();
    if (widget?.topicList == null) {
      loadData(widget.path);
    } else {
      loadData(null);
    }
  }

  @override
  void didUpdateWidget(TopicListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.path = oldWidget.path;
    widget.topicList = oldWidget.topicList;
    widget.pager = oldWidget.pager;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        color: Theme.of(context).accentColor,
        onRefresh: () async {
          refreshing = true;
          await loadData(widget.path);
        },
        child: Column(
          children: <Widget>[
            Row(),
            Flexible(
                child: Stack(
              children: <Widget>[
                getMainContent(),
                getProgress(),
              ],
            )),
            getPagerWidget(),
          ],
        ));
  }

  Future<void> loadData(String path) async {
    if (path == null) {
      setState(() {});
    } else {
      loading = true;
      if (refreshing) {
        loading = false;
      }
      setState(() {});
      var result = await service.getTopicList(path: path);
      widget.pager = result.pager;
      widget.topicList = result.itemList;
      widget.path = path;
      noContent = widget.topicList == null || widget.topicList.length == 0;
      loading = false;
      refreshing = false;
      setState(() {});
    }
  }

  Widget getMainContent() {
    if (noContent) {
      return EmptyWidget();
    } else if (widget.topicList != null) {
      return getListView();
    } else {
      return Container(width: 0);
    }
  }

  Widget getListView() {
    return ListView.builder(
      itemCount: widget.topicList.length,
      itemBuilder: (context, index) {
        var topic = widget.topicList[index];
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EntriesWidget(topic)),
            );
          },
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: topic.detail != null
                      ? <Widget>[
                          Text(topic.detail,
                              style: Theme.of(context).textTheme.display1),
                          Text(
                            topic.title,
                            style: Theme.of(context).textTheme.body1,
                          )
                        ]
                      : <Widget>[
                          Text(
                            topic.title,
                            style: Theme.of(context).textTheme.body1,
                          )
                        ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text("        "), Text(topic.badge)],
              )
            ],
          ),
        );
      },
    );
  }

  Widget getProgress() {
    return Container(child: !loading ? Row() : LoadingWidget());
  }

  Widget getPagerWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 5),
        child: Container(
            height: 50,
            child: widget.pager != null
                ? PagerWidget(widget.pager, handleOnMore, handleOnPage)
                : Container(
                    height: 1,
                  )),
      ),
    );
  }

  handleOnMore(path) async {
    await loadData(path);
  }

  handleOnPage(page) async {
    var path = EksiUri.getPathForPage(widget.path, page);
    widget.path = path;
    loadData(path);
    scrollToTop();
  }

  scrollToTop() {
    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
    setState(() => {});
  }
}
