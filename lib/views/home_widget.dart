import 'package:eksi_reader/models/section.dart';
import 'package:eksi_reader/services/eksi_service.dart';
import 'package:eksi_reader/views/topic_list.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
  List<Section> sectionList;  

  @override
  State createState() => new HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget>
    with SingleTickerProviderStateMixin {
  
  EksiService service = EksiService();
  TabController controller;

  @override
  void initState() {
    super.initState();
    loadSections();
  }

  @override
  void didUpdateWidget(HomeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.sectionList = oldWidget.sectionList;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sectionList == null) {
      return Scaffold(
        appBar: AppBar(
            title:
                Text('EksiReader', maxLines: 2, style: TextStyle(fontSize: 16))),
      );
    }
    return Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              isScrollable: true,
              controller: controller,
              tabs: getTabs(),
            ),
            title:
                Text('EksiReader', maxLines: 2, style: TextStyle(fontSize: 16)),
          ),
          body: getTabBarsView(),
        );
  }

  Future<void> loadSections () async {
    await service.login();
    widget.sectionList = await service.getSectionList();
    controller = new TabController(length: widget.sectionList.length, vsync: this);
    setState(() {});
  }

  getTabs() {
    var tabList = new List<Tab>();
    if (widget.sectionList != null) {
      for(var section in widget.sectionList) {
        var tab = Tab(text: section.title);
        tabList.add(tab);
      }
    }
    return tabList;
  }

  getTabBarsView() {
    var entryWidgets = new List<Widget>();
    if (widget.sectionList != null) {
      for(var section in widget.sectionList) {
        var widget = Center(
          child: TopicListWidget(
            path: section.path
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
