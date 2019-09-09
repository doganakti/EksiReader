import 'package:eksi_reader/models/entry.dart';
import 'package:eksi_reader/models/topic.dart';
import 'package:eksi_reader/results/result.dart';
import 'package:eksi_reader/services/eksi_service.dart';
import 'package:eksi_reader/views/entry_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:share/share.dart';

import 'modal_widget.dart';

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
  EksiService service = EksiService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(EntriesWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: AppBar(
            title: Text(topic.title, maxLines: 2),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                ModalWidget modalWidget = new ModalWidget();
                var widgets = new List<Widget>();
                widgets.add(new ListTile(
                  leading: Icon(Icons.person_add),
                  title: Text("başlığı takip et")
                ));
                widgets.add(new ListTile(
                  leading: Icon(Icons.share),
                  title: Text("paylaş"),
                  onTap: () {
                    Navigator.pop(context);
                    Share.share('https://eksisozluk.com${widget.topic.path}');
                  },
                ));
                modalWidget.mainButtomSheet(context, widgets);
                },
              ),
              IconButton(
                icon: Icon(Icons.message),
                onPressed: () {
                  
                },
              )
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: EntryListWidget(path: widget.topic.path),
            ),
          ],
        ));
  }
}
