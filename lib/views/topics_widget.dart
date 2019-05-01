import 'package:eksi_reader/models/section.dart';
import 'package:eksi_reader/services/eksi_service.dart';
import 'package:eksi_reader/services/login_service.dart';
import 'package:eksi_reader/views/login_widget.dart';
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
  LoginService loginService = new LoginService();

  @override
  void initState() {
    super.initState();
    loadData('/basliklar/gundem');
  }

  Future<Null> loadData(String path) async {
    await new Future.delayed(new Duration(seconds: 1));
    var login = await service.login();
    var sectionList = await service.getSectionList();
    for (var section in sectionList) {
      section.topicList = await service.getTopicList(path: section.path);
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
        onRefresh: () async {
          section.topicList = await service.getTopicList(path: section.path);
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
              onPressed: () {
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
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white))),
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
                  onPressed: () {
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

  @override
  TopicsContentWidgetState createState() {
    return new TopicsContentWidgetState();
  }
}

class TopicsContentWidgetState extends State<TopicsContentWidget> {
  @override
  Widget build(BuildContext context) {
    var listView = getListView();
    return new Container(
      padding: EdgeInsets.only(bottom: 20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          Expanded(
            child: SizedBox(child: listView),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(" "),
              new IconButton(icon: Icon(Icons.first_page), onPressed: () {}, iconSize: 40),
              new IconButton(icon: Icon(Icons.keyboard_arrow_left), onPressed: () {}, iconSize: 40),
              new Text('Page'),
              new IconButton(icon: Icon(Icons.keyboard_arrow_right), onPressed: () {}, iconSize: 40),
              new IconButton(icon: Icon(Icons.last_page), onPressed: () {}, iconSize: 40),
              new Text(" "),
            ],
          ),
          Row(
          )
        ]));
  }

  ListView getListView() {
    var listView = ListView.builder(
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
                      : <Widget>[Text(topic.title)],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text("        "), Text(topic.badge)],
              )
            ],
          ),
          onTap: () {
            print(index);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TopicsWidget()),
            );
          },
        );
        return listTile;
      },
    );
    return listView;
  }
}
