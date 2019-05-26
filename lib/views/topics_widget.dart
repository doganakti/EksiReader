import 'package:eksi_reader/models/eksi_uri.dart';
import 'package:eksi_reader/models/section.dart';
import 'package:eksi_reader/services/eksi_service.dart';
import 'package:eksi_reader/services/login_service.dart';
import 'package:eksi_reader/views/login_widget.dart';
import 'package:eksi_reader/views/entries_widget.dart';
import 'package:eksi_reader/views/pager_widget.dart';
import 'package:flutter/material.dart';

class TopicsWidget extends StatefulWidget {
  @override
  State createState() => new TopicsWidgetState();
}

class TopicsWidgetState extends State<TopicsWidget>
    with SingleTickerProviderStateMixin {
  List<Section> _sectionList;
  var service = new EksiService();
  TabController controller;
  LoginWidget loginWidget;

  @override
  void initState() {
    super.initState();
    loadData('/basliklar/gundem');
  }

  Future<Null> loadData(String path) async {
    await new Future.delayed(new Duration(seconds: 1));
    await service.login();
    var sectionList = await service.getSectionList();
    for (var section in sectionList) {
      var result = await service.getTopicList(path: section.path);
      section.topicList = result.itemList;
      section.pager = result.pager;
    }
    controller = new TabController(length: sectionList.length, vsync: this);
    setState(() {
      _sectionList = sectionList;
    });
    return null;
  }

  TabBar getTabBar() {
    List<Tab> tabList = new List<Tab>();
    for (var section in _sectionList) {
      tabList.add(new Tab(text: section.title));
    }
    return new TabBar(
        tabs: tabList, isScrollable: true, controller: controller);
  }

  TabBarView getTabBarView(var tabs) {
    return new TabBarView(
      children: tabs,
      controller: controller,
    );
  }

  RefreshIndicator getTabBarViewChild(Section section) {
    var topicsContentWidget = TopicsContentWidget(section);
    return RefreshIndicator(
        backgroundColor: Theme.of(context).primaryColor,
        color: Colors.white,
        onRefresh: () async {
          var result = await service.getTopicList(path: section.path);
          section.topicList = result.itemList;
          section.pager = result.pager;
          setState(() {
            topicsContentWidget.section = section;
          });
        },
        child: topicsContentWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (_sectionList == null) {
      return new Scaffold(
        appBar: new AppBar(
          leading: IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () async {
                print("hey");
              }),
          title: new Text("EksiReader"),
          actions: <Widget>[
            // action button
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  print("hey");
                })
          ],
        ),
        body: const Center(
            child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey))),
      );
    }
    var tabBarViewChildren = new List<RefreshIndicator>();
    for (var section in _sectionList) {
      tabBarViewChildren.add(getTabBarViewChild(section));
    }
    var scaffold = new Scaffold(
        appBar: new AppBar(
            leading: IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () async {
                  print("hey");
                  if (loginWidget == null) {
                    loginWidget = new LoginWidget();
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => loginWidget),
                  );
                  //await service.login();
                }),
            title: new Text("EksiReader"),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () async {
                    print("hey");
                  })
            ],
            bottom: getTabBar()),
        body: TabBarView(
          physics: ScrollPhysics(),
          children: tabBarViewChildren,
          controller: controller,
        ));
    return scaffold;
  }
}

class TopicsContentWidget extends StatefulWidget {
  Section section;
  TopicsContentWidget(this.section);
  var service = new EksiService();
  @override
  TopicsContentWidgetState createState() {
    return TopicsContentWidgetState();
  }
}

class TopicsContentWidgetState extends State<TopicsContentWidget> {
  @override
  Widget build(BuildContext context) {
    var listView = getListView();
    var pagerWidget =
        PagerWidget(widget.section.pager, handleOnMore, handleOnPage);
    return Stack(
                children: <Widget>[
                  listView,
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 20),
                    child: Container(
                      height: 64,
                      child: pagerWidget
                    ),
                  )
                ],
              );
  }

  handleOnMore(path) async {
    var result = await widget.service.getTopicList(path: path);
    widget.section.topicList = result.itemList;
    widget.section.pager = result.pager;
    setState(() {});
  }

  handleOnPage(page) async {
    var path = EksiUri.getPathForPage(widget.section.path, page);
    var result = await widget.service.getTopicList(path: path);
    widget.section.topicList = result.itemList;
    widget.section.pager = result.pager;
    setState(() {});
  }

  ListView getListView() {
    var listView = ListView.builder(
      padding: EdgeInsets.only(bottom: 84),
      itemCount: widget.section.topicList?.length,
      physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var topic = widget.section.topicList[index];
        var listTile = ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: topic.detail != null
                      ? <Widget>[
                          Text(topic.detail,
                              style: TextStyle(color: Colors.green)),
                          Text(topic.title)
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EntriesWidget(topic)),
            );
          },
        );
        return listTile;
      },
    );
    return listView;
  }
}
