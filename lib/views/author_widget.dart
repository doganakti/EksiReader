import 'package:eksi_reader/models/author.dart';
import 'package:eksi_reader/models/section.dart';
import 'package:eksi_reader/services/eksi_service.dart';
import 'package:eksi_reader/views/entry_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AuthorWidget extends StatefulWidget {
  Author author;
  AuthorWidget(this.author);
  @override
  State createState() => AuthorWidgetState(author);
}

class AuthorWidgetState extends State<AuthorWidget>
    with SingleTickerProviderStateMixin {
  Author author;
  AuthorWidgetState(this.author);
  EksiService service = EksiService();
  List<Section> sectionList;
  TabController controller;

  @override
  void initState() {
    super.initState();
    loadSections(author);
  }

  loadSections(Author author) async {
    var result = await service.getAuthorSections(author: author);
    setState(() {
      sectionList = result.itemList;
      controller = new TabController(length: sectionList.length, vsync: this);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (sectionList == null) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: AppBar(
            title:
                Text(author.name, maxLines: 2))
        ),
      );
    }
    return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: AppBar(
            bottom: TabBar(
              isScrollable: true,
              controller: controller,
              tabs: getTabs(),
            ),
            title:
                Text(author.name, maxLines: 2),
          ),
          ),
          body: getTabBarsView(),
        );
  }

  getTabs() {
    var tabList = new List<Tab>();
    if (sectionList != null) {
      for(var section in sectionList) {
        var tab = Tab(text: section.title);
        tabList.add(tab);
      }
    }
    return tabList;
  }

  getTabBarsView() {
    var entryWidgets = new List<Widget>();
    if (sectionList != null) {
      for(var section in sectionList) {
        var widget = Center(
          child: EntryListWidget(
            path: section.path,
            author: author,
            section: section,
            page: 1,
          )
        );
        entryWidgets.add(widget);
      }
    }
    var tabbarView = TabBarView(
      controller: controller,
      children: entryWidgets
    );
    return tabbarView;
  }
}
