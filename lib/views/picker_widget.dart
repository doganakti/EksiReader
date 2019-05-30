import 'package:eksi_reader/models/settings_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PickerWidget {
  List<SettingsContent> contentList;
  Function(String) action;
  PickerWidget(this.contentList, this.action);

  mainBottomSheet(BuildContext context) {
    var tiles = getListView(context);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: tiles,
            ),
          );
        });
  }

  List<Widget> getListView(Object context) {
    var tiles = contentList
        .map((content) => ListTile(
              title: Text(content.title),
              onTap: () {
                Navigator.pop(context);
                action(content.value);
              },
            ))
        .toList();
    return tiles;
  }
}
