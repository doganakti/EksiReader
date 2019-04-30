import 'package:eksi_reader/services/eksi_service.dart';
import 'package:eksi_reader/views/topics_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var materialApp = new MaterialApp(
        title: 'EksiReader',
        home: new TopicsWidget(),
        theme: ThemeData(
          // Define the default Brightness and Colors
          brightness: Brightness.dark,
          primaryColor: Color(0xff303030),
          primarySwatch: Colors.purple,
          accentColor: Colors.cyan[600],

          // Define the default Font Family
          fontFamily: 'Montserrat',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ));

    return materialApp;
  }
}
