import 'package:eksi_reader/models/section.dart';
import 'package:eksi_reader/services/eksi_service.dart';
import 'package:eksi_reader/views/account_widget.dart';
import 'package:eksi_reader/views/loading_widget.dart';
import 'package:eksi_reader/views/login_widget.dart';
import 'package:eksi_reader/views/search_widget.dart';
import 'package:eksi_reader/views/settings_widget.dart';
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
        body: Container()//LoadingWidget(),
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(90),
          child: AppBar(
            bottom: TabBar(
              isScrollable: true,
              controller: controller,
              tabs: getTabs(),
            ),
            leading: IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () async {
                  var author = await service.getAuthor();
                  author = await service.getAuthorDetail(author: author);
                  var accountWidget = AccountWidget();
                  accountWidget.presentModal(context, user: author);
                }),
            title: Text('EksiReader', maxLines: 2),
            actions: <Widget>[
              // action button
              IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsWidget()),
                    );
                  }),
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(context: context, delegate: SearchWidget());
                  })
            ],
          )),
      body: getTabBarsView(),
    );
  }

  Future<void> loadSections() async {
    await service.login();
    widget.sectionList = await service.getSectionList();
    controller =
        new TabController(length: widget.sectionList.length, vsync: this);
    await service.getAuthorDetail();
    setState(() {});
  }

  getTabs() {
    var tabList = new List<Tab>();
    if (widget.sectionList != null) {
      for (var section in widget.sectionList) {
        var tab = Tab(text: section.title);
        tabList.add(tab);
      }
    }
    return tabList;
  }

  getTabBarsView() {
    var entryWidgets = new List<Widget>();
    if (widget.sectionList != null) {
      for (var section in widget.sectionList) {
        var widget = Center(child: TopicListWidget(path: section.path));
        entryWidgets.add(widget);
      }
    }
    var tabbarView = TabBarView(controller: controller, children: entryWidgets);
    return tabbarView;
  }
}
