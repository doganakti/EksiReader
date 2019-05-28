import 'dart:async';

import 'package:eksi_reader/models/author.dart';
import 'package:eksi_reader/models/eksi_uri.dart';
import 'package:eksi_reader/models/entry.dart';
import 'package:eksi_reader/models/topic.dart';
import 'package:eksi_reader/results/result.dart';
import 'package:eksi_reader/services/eksi_service.dart';
import 'package:eksi_reader/views/empty_widget.dart';
import 'package:eksi_reader/views/entry_list_widget.dart';
import 'package:eksi_reader/views/entry_widget.dart';
import 'package:eksi_reader/views/pager_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sticky_header_list/sticky_header_list.dart';

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
              child: EntryListWidget(path: this.widget.topic.path),
            ),
          ],
        ));
  }
}
