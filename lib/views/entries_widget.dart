import 'package:eksi_reader/models/entry.dart';
import 'package:eksi_reader/models/topic.dart';
import 'package:eksi_reader/results/result.dart';
import 'package:eksi_reader/services/eksi_service.dart';
import 'package:eksi_reader/views/entry_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
        appBar: AppBar(
            title:
                Text(topic.title, maxLines: 2, style: TextStyle(fontSize: 16))),
        body: Column(
          children: <Widget>[
            Flexible(
              child: EntryListWidget(path: widget.topic.path),
            ),
          ],
        ));
  }
}
