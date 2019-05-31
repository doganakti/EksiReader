import 'package:flutter/material.dart';

class Topic {
  String title;
  String detail;
  String path;
  String url;
  String badge;
  Icon icon;

  Topic(this.title, this.detail, this.path, this.badge) {
    if(path.contains('/biri')) {
      icon = Icon(Icons.account_circle);
    } else {
      icon = Icon(Icons.text_fields);
    }
  }
}
