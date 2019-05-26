import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData dark() {
    var brightness = Brightness.dark; 
    var themeData = ThemeData(
        // Define the default Brightness and Colors
        // deepOrangeAccent
        // Color(0xff1da1f2)
        brightness: brightness,
        primaryColor: brightness == Brightness.dark ? Color(0xff303030) : Colors.blueGrey,
        primarySwatch: brightness == Brightness.dark ? Colors.blueGrey : Colors.blueGrey,
        accentColor: brightness == Brightness.dark ? Colors.white : Colors.white,
        scaffoldBackgroundColor: brightness == Brightness.dark ? Color(0xff303030) : Color(0xfff6f1e6),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor:brightness == Brightness.dark ? Color(0xff303030) : Colors.blueGrey, 
          foregroundColor: Colors.white,
        ),
        
        // Define the default Font Family
        fontFamily: 'Roboto',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            button: TextStyle(fontSize: 16.0),
            overline: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            
            // ***** Entry Topic Header ****
            title: TextStyle(fontSize: 16.0),
            
            // **** Default Subtitle ****
            caption: TextStyle(fontSize: 18.0),

            // **** Default ListView Title ****
            subhead: TextStyle(fontSize: 16.0), // ListView Title
            
            // **** Entry Content ****
            body1: TextStyle(fontSize: 15.0, fontWeight: brightness == Brightness.dark ? FontWeight.w400 : FontWeight.w500),

            // **** Topic ****
            body2: TextStyle(fontSize: 36.0),

            // **** Author ****
            display1: TextStyle(
                color: Colors.green,
                fontSize: 14,
                fontWeight: FontWeight.w500),

            // **** Date ****
            display2: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w400),
            
            // **** Url ***
            display3: TextStyle(
                color: brightness == Brightness.dark ? Colors.orangeAccent : Color(0xffa16523),
                fontSize: 15, fontWeight: brightness == Brightness.dark ? FontWeight.w400 : FontWeight.w500)));

    return themeData;
  }
}
