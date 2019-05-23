import 'package:eksi_reader/models/app_theme.dart';
import 'package:eksi_reader/services/eksi_service.dart';
import 'package:eksi_reader/views/topics_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var materialApp = new MaterialApp(
        title: 'EksiReader', home: new TopicsWidget(), theme: AppTheme.dark());

    return materialApp;
  }
}
