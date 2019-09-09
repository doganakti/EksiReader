import 'package:eksi_reader/app.dart';
import 'package:flutter/material.dart';

class ModalWidget {
  mainButtomSheet(BuildContext context, List<Widget> widgets) {
    widgets.add(new Container(height:30));
    showModalBottomSheet(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        context: context,
        builder: (BuildContext context) {
          return Column(mainAxisSize: MainAxisSize.min, children: widgets);
        });
  }
}
