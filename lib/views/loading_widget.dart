import 'package:eksi_reader/views/color_loader_3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 64,
        height:64,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          elevation: 2,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Container(padding: EdgeInsets.all(0), child: ColorLoader3()))
      )
    );
  }
}
