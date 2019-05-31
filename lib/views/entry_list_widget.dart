import 'package:eksi_reader/models/author.dart';
import 'package:eksi_reader/models/eksi_uri.dart';
import 'package:eksi_reader/models/entry.dart';
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
  EntryListWidget({this.path, this.author, this.section, this.page: 1});
  @override
  EntryListWidgetState createState() => EntryListWidgetState();
}

class EntryListWidgetState extends State<EntryListWidget> {
  EksiService service = EksiService();
  bool loading = true;
  bool noContent = false;
  ScrollController scrollController;
  Pager pager;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(initialScrollOffset: -00.0);

    loadData(this.widget.path);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }

  @override
  void didUpdateWidget(EntryListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.path = oldWidget.path;
    widget.entryList = oldWidget.entryList;
  }

  loadData(String path) async {
    loading = true;
    var result = widget.author == null
        ? await service.getEntryList(path: path)
        : await service.getAuthorEntryList(
            widget.author, widget.section, widget.page);
    setState(() {
      widget.entryList = result.itemList;
      pager = result.pager;
      widget.path = result.topic?.path;
      loading = false;
      noContent = widget.entryList?.length == 0;
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
    var listView = ListView.separated(
      controller: scrollController,
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey[600],
      ),
      itemCount: widget.entryList.length,
      itemBuilder: (context, index) {
        var entry = widget.entryList[index];
        entry.onUrl = handleOnUrl;
        return ListTile(
          title: EntryWidget(
          entry: entry, separator: widget.entryList.last.id != entry.id),
        );
      }
    );
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
        padding: EdgeInsets.only(bottom: 5),
        child: Container(
            height: 50,
            child: pager != null
                ? PagerWidget(pager, handleOnMore, handleOnPage)
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
    widget.path = path;
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
