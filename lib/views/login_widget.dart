import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_keychain/flutter_keychain.dart';

class LoginWidget extends StatefulWidget {
  @override
  State createState() => new LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      withJavascript: true,
      url: "https://eksisozluk.com/giris",
      withZoom: false,
      withLocalStorage: true,
      hidden: false,      
      appBar: new AppBar(
        title: new Text("Giriş"),
      ),
    );
  }
}
