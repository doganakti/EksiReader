import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:eksi_reader/models/app_theme.dart';
import 'package:eksi_reader/services/eksi_service.dart';
import 'package:eksi_reader/views/home_widget.dart';
import 'package:eksi_reader/views/topics_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keychain/flutter_keychain.dart';

class App extends StatefulWidget {
  @override
  State createState() => new AppState();
}

class AppState extends State<App> {
  String themeKey;
  double fontSize; 
  String fontFamily;

  @override
  void initState() {
    setup();
  }

  Future<void> setup() async {
    themeKey = await FlutterKeychain.get(key: 'Tema');
    var fontSizeKey = await FlutterKeychain.get(key: 'FontSize');
    fontFamily = await FlutterKeychain.get(key: 'FontFamily');

    if (themeKey == null) {
      await FlutterKeychain.put(key: 'Tema', value: 'Klasik');
      themeKey = 'Klasik';
    }

    if (fontSizeKey == null) {
      await FlutterKeychain.put(key: 'FontSize', value: '15');
      fontSizeKey = '15';
    }

    if (fontFamily == null) {
      await FlutterKeychain.put(key: 'FontFamily', value: 'Roboto');
      fontFamily = 'Roboto';
    }

    fontSize = double.parse(fontSizeKey);

    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return themeKey == null ? new Container() : DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => AppTheme.theme(themeKey, fontSize, fontFamily),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            title: 'EksiReader',
            theme: theme,
            home: new HomeWidget(),
          );
        });
  }
}
