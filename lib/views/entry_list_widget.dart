import 'package:eksi_reader/models/author.dart';
import 'package:eksi_reader/models/disambiguation.dart';
import 'package:eksi_reader/models/eksi_uri.dart';
import 'package:eksi_reader/models/entry.dart';
import 'package:eksi_reader/models/more.dart';
import 'package:eksi_reader/models/pager.dart';
import 'package:eksi_reader/models/section.dart';
import 'package:eksi_reader/models/topic.dart';
import 'package:eksi_reader/services/eksi_service.dart';
import 'package:eksi_reader/views/empty_widget.dart';
import 'package:eksi_reader/views/loading_widget.dart';
import 'package:eksi_reader/views/pager_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sticky_header_list/sticky_header_list.dart';
import 'package:sticky_header_list/sticky_row.dart';
import 'package:url_launcher/url_launcher.dart';

import 'entries_widget.dart';
import 'entry_widget.dart';

class EntryListWidget extends StatefulWidget {
  String path;
  Author author;
  Section section;
  int page;
  List<Entry> entryList;
  bool separator;
  Pager pager;
  More more;
  Disambiguation disambiguation;

  EntryListWidget({this.path, this.author, this.section, this.page: 1});
  @override
  EntryListWidgetState createState() => EntryListWidgetState();
}

class EntryListWidgetState extends State<EntryListWidget> {
  EksiService service = EksiService();
  bool loading = true;
  bool noContent = false;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(initialScrollOffset: -00.0);

    loadData(this.widget.path);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
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
      ),
      onRefresh: () async {
        await loadData(widget.path);
      },
    );
  }

  @override
  void didUpdateWidget(EntryListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.path = oldWidget.path;
    widget.entryList = oldWidget.entryList;
    widget.section = oldWidget.section;
    widget.page = oldWidget.page;
    widget.author = oldWidget.author;
    widget.separator = oldWidget.separator;
    widget.pager = oldWidget.pager;
    widget.more = oldWidget.more;
    widget.disambiguation = oldWidget.disambiguation;
  }

  loadData(String path) async {
    loading = true;
    var result = widget.author == null
        ? await service.getEntryList(path: path)
        : await service.getAuthorEntryList(
            author: widget.author,
            section: widget.section,
            page: widget.page,
            pager: widget.pager);
    setState(() {
      widget.entryList = result.itemList;
      widget.pager = result.pager;
      widget.more = result.more;
      widget.disambiguation = result.disambiguation;
      if (!path.contains('nick=')) {
        widget.path = result.topic?.path;
        widget.path = EksiUri.removeFocusToFromPath(widget.path);
      }
      loading = false;
      noContent = widget.entryList.isEmpty;
    });
  }

  Widget getMainContent() {
    if (noContent) {
      return EmptyWidget();
    } else if (widget.entryList != null) {
      return getListView();
    } else {
      return Container(width: 0);
    }
  }

  Widget getListViewWithHeader() {
    var stickyListItems = new List<StickyListRow>();
    var header = new HeaderRow(child: Container(height: 0));
    stickyListItems.add(header);
    for (var entry in widget.entryList) {
      entry.onUrl = handleOnUrl;
      var entryWidget = EntryWidget(
          entry: entry, separator: widget.entryList.last.id != entry.id);
      var entryRow = new RegularRow(child: entryWidget);
      stickyListItems.add(entryRow);
    }
    var headerContainer =
        new StickyList(children: stickyListItems, controller: scrollController);
    return headerContainer;
  }

  Widget getListView() {
    var itemCount = widget.entryList.length;
    if (widget.disambiguation != null || widget.more != null) {
      itemCount = widget.entryList.length + 1;
    }
    var listView = ListView.separated(
        controller: scrollController,
        separatorBuilder: (context, index) => Divider(
              color: Colors.grey[700],
            ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (widget.more == null && widget.disambiguation == null) {
            var entry = widget.entryList[index];
            entry.onUrl = handleOnUrl;
            return ListTile(
              title: EntryWidget(
                  entry: entry,
                  separator: widget.entryList.last.id != entry.id),
            );
          } else {
            if (index == 0) {
              if (widget.more != null) {
                return InkWell(
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 15, bottom: 5),
                      height: 45,
                      child: Text(widget.more.text,
                          style: Theme.of(context).textTheme.display3),
                    ),
                  ),
                  onTap: () async {
                    await loadData(widget.more.path);
                  },
                );
              } else if (widget.disambiguation != null) {
                return InkWell(
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 15, bottom: 5),
                      height: 45,
                      child: Text(
                          'Aynı isimde "' +
                              widget.disambiguation.title +
                              '" başlığı da var',
                          style: Theme.of(context).textTheme.display3),
                    ),
                  ),
                  onTap: () async {
                    var topic = Topic(widget.disambiguation.title, null,
                        widget.disambiguation.path, null);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EntriesWidget(topic)),
                    );
                  },
                );
              }
            } else {
              var entry = widget.entryList[index - 1];
              entry.onUrl = handleOnUrl;
              return ListTile(
                title: EntryWidget(
                    entry: entry,
                    separator: widget.entryList.last.id != entry.id),
              );
            }
          }
        });
    return listView;
  }

  Widget getProgress() {
    return Container(child: !loading ? Row() : LoadingWidget());
  }

  Widget getPagerWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 15),
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
    var result = await service.getEntryList(path: path);
    widget.entryList = result.itemList;
    setState(() {});
  }

  handleOnPage(page) async {
    setState(() {
      loading = true;
    });
    var path = EksiUri.getPathForPage(widget.path, page);
    if (!path.contains('nick=')) {
      widget.path = path;
    }
    widget.page = page;
    loadData(path);
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
    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
    setState(() => {});
  }
}
