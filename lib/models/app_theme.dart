import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData dark() {
    var themeData = ThemeData(
        // Define the default Brightness and Colors
        brightness: Brightness.dark,
        primaryColor: Color(0xff303030),
        primarySwatch: Colors.purple,
        accentColor: Colors.cyan[600],

        // Define the default Font Family
        fontFamily: 'Roboto',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            button: TextStyle(fontSize: 18.0),
            overline: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            
            // ***** Entry Topic Header ****
            title: TextStyle(fontSize: 18.0),
            
            // **** Default Subtitle ****
            caption: TextStyle(fontSize: 18.0),

            // **** Default ListView Title ****
            subhead: TextStyle(fontSize: 16.0), // ListView Title
            
            // **** Entry Content ****
            body1: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),

            // **** Topic ****
            body2: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),

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
                color: Colors.orangeAccent,
                fontSize: 15)));

    return themeData;
  }
}
