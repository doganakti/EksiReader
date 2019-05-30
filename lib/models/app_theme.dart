import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData dark(double fontSize, String fontFamily) {
    var brightness = Brightness.dark; 
    var themeData = ThemeData(
        // Define the default Brightness and Colors
        // deepOrangeAccent
        // Color(0xff1da1f2)
        brightness: brightness,
        primaryColor: Color(0xff303030),
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.orange,
        scaffoldBackgroundColor: Color(0xff303030),
        appBarTheme: AppBarTheme(textTheme: TextTheme(title: TextStyle(fontSize: fontSize + 3, color: Colors.white, fontWeight: FontWeight.w500))),

        // Define the default Font Family
        fontFamily: fontFamily,

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
            // ***** Button ****
            button: TextStyle(fontSize: fontSize),
            
            // ***** Entry Topic Header ****
            title: TextStyle(fontSize: fontSize + 1),
            
            // **** Default Subtitle ****
            caption: TextStyle(fontSize: fontSize + 3),

            // **** Default ListView Title ****
            subhead: TextStyle(fontSize: fontSize + 1), // ListView Title
            
            // **** Entry Content ****
            body1: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w400),

            // **** Topic ****
            body2: TextStyle(fontSize: fontSize),

            // **** Author ****
            display1: TextStyle(
                color: Colors.green,
                fontSize: fontSize  -1,
                fontWeight: FontWeight.w500),

            // **** Date ****
            display2: TextStyle(
                color: Colors.grey[600],
                fontSize: fontSize - 3,
                fontWeight: FontWeight.w400),
            
            // **** Url ***
            display3: TextStyle(
                color: Colors.orangeAccent,
                fontSize: fontSize, 
                fontWeight: FontWeight.w400)));

            

    return themeData;
  }

  static ThemeData light(double fontSize, String fontFamily) {
    var brightness = Brightness.light;
    var themeData = ThemeData(
        // Define the default Brightness and Colors
        // deepOrangeAccent
        // Color(0xff1da1f2)
        brightness: brightness,
        primaryColor: Color(0xfff6f1e6),
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.black87,
        scaffoldBackgroundColor: Color(0xfff6f1e6),
        
        appBarTheme: AppBarTheme(textTheme: TextTheme(title: TextStyle(fontSize: fontSize + 3, color: Colors.black, fontWeight: FontWeight.w500))),

        // Define the default Font Family
        fontFamily: fontFamily,

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
            button: TextStyle(fontSize: fontSize + 1),
            
            // ***** Entry Topic Header ****
            title: TextStyle(fontSize: fontSize + 1),
            
            // **** Default Subtitle ****
            caption: TextStyle(fontSize: fontSize + 1),

            // **** Default ListView Title ****
            subhead: TextStyle(fontSize: fontSize + 1), // ListView Title
            
            // **** Entry Content ****
            body1: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),

            // **** Topic ****
            body2: TextStyle(fontSize: fontSize),

            // **** Author ****
            display1: TextStyle(
                color: Colors.green,
                fontSize: fontSize - 1,
                fontWeight: FontWeight.w500),

            // **** Date ****
            display2: TextStyle(
                color: Colors.grey[600],
                fontSize: fontSize - 3,
                fontWeight: FontWeight.w400),
            
            // **** Url ***
            display3: TextStyle(
                color: Color(0xffa16523),
                fontSize: fontSize,
                fontWeight: FontWeight.w500),
            
            // **** Info ****
            display4: TextStyle(
                color: Colors.grey[600],
                fontSize: fontSize - 1,
                fontWeight: FontWeight.bold)));

    return themeData;
  }

  static ThemeData orange(double fontSize, String fontFamily) {
    var brightness = Brightness.light;
    var themeData = ThemeData(
        // Define the default Brightness and Colors
        // deepOrangeAccent
        // Color(0xff1da1f2)
        brightness: brightness,
        primaryColor: Colors.deepOrange,
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.black87,
        scaffoldBackgroundColor: Color(0xfff6f1e6),
        
        appBarTheme: AppBarTheme(textTheme: TextTheme(title: TextStyle(fontSize: fontSize + 3, color: Colors.white, fontWeight: FontWeight.w500))),

        // Define the default Font Family
        fontFamily: fontFamily,

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
            button: TextStyle(fontSize: fontSize),
            
            // ***** Entry Topic Header ****
            title: TextStyle(fontSize: fontSize + 3),
            
            // **** Default Subtitle ****
            caption: TextStyle(fontSize: fontSize + 3),

            // **** Default ListView Title ****
            subhead: TextStyle(fontSize: fontSize + 1), // ListView Title
            
            // **** Entry Content ****
            body1: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),

            // **** Topic ****
            body2: TextStyle(fontSize: 36.0),

            // **** Author ****
            display1: TextStyle(
                color: Colors.green,
                fontSize: fontSize - 1,
                fontWeight: FontWeight.w500),

            // **** Date ****
            display2: TextStyle(
                color: Colors.grey[600],
                fontSize: fontSize - 3,
                fontWeight: FontWeight.w400),
            
            // **** Url ***
            display3: TextStyle(
                color: Color(0xffa16523),
                fontSize: fontSize,
                fontWeight: FontWeight.w500),
            
            // **** Info ****
            display4: TextStyle(
                color: Colors.grey[600],
                fontSize: fontSize - 1,
                fontWeight: FontWeight.bold)));

    return themeData;
  }

  static ThemeData sky(double fontSize, String fontFamily) {
    var brightness = Brightness.light;
    var themeData = ThemeData(
        // Define the default Brightness and Colors
        // deepOrangeAccent
        // Color(0xff1da1f2)
        brightness: brightness,
        primaryColor: Colors.lightBlueAccent,
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.black87,
        scaffoldBackgroundColor: Color(0xfff6f1e6),
        
        appBarTheme: AppBarTheme(textTheme: TextTheme(title: TextStyle(fontSize: fontSize + 3, color: Colors.white, fontWeight: FontWeight.w500))),

        // Define the default Font Family
        fontFamily: fontFamily,

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
            button: TextStyle(fontSize: fontSize),
            
            // ***** Entry Topic Header ****
            title: TextStyle(fontSize: fontSize + 3),
            
            // **** Default Subtitle ****
            caption: TextStyle(fontSize: fontSize + 3),

            // **** Default ListView Title ****
            subhead: TextStyle(fontSize: fontSize + 1), // ListView Title
            
            // **** Entry Content ****
            body1: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),

            // **** Topic ****
            body2: TextStyle(fontSize: 36.0),

            // **** Author ****
            display1: TextStyle(
                color: Colors.green,
                fontSize: fontSize - 1,
                fontWeight: FontWeight.w500),

            // **** Date ****
            display2: TextStyle(
                color: Colors.grey[600],
                fontSize: fontSize - 3,
                fontWeight: FontWeight.w400),
            
            // **** Url ***
            display3: TextStyle(
                color: Color(0xffa16523),
                fontSize: fontSize,
                fontWeight: FontWeight.w500),
            
            // **** Info ****
            display4: TextStyle(
                color: Colors.grey[600],
                fontSize: fontSize - 1,
                fontWeight: FontWeight.bold)));

    return themeData;
  }

  static ThemeData hot(double fontSize, String fontFamily) {
    var brightness = Brightness.light;
    var themeData = ThemeData(
        // Define the default Brightness and Colors
        // deepOrangeAccent
        // Color(0xff1da1f2)
        brightness: brightness,
        primaryColor: Colors.red,
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.red,
        scaffoldBackgroundColor: Colors.grey[200],
        
        appBarTheme: AppBarTheme(textTheme: TextTheme(title: TextStyle(fontSize: fontSize + 3, color: Colors.white, fontWeight: FontWeight.w500))),

        // Define the default Font Family
        fontFamily: fontFamily,

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
            button: TextStyle(fontSize: fontSize),
            
            // ***** Entry Topic Header ****
            title: TextStyle(fontSize: fontSize + 3),
            
            // **** Default Subtitle ****
            caption: TextStyle(fontSize: fontSize + 3),

            // **** Default ListView Title ****
            subhead: TextStyle(fontSize: fontSize + 1), // ListView Title
            
            // **** Entry Content ****
            body1: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),

            // **** Topic ****
            body2: TextStyle(fontSize: 36.0),

            // **** Author ****
            display1: TextStyle(
                color: Colors.green,
                fontSize: fontSize - 1,
                fontWeight: FontWeight.w500),

            // **** Date ****
            display2: TextStyle(
                color: Colors.grey[600],
                fontSize: fontSize - 3,
                fontWeight: FontWeight.w400),
            
            // **** Url ***
            display3: TextStyle(
                color: Colors.red,
                fontSize: fontSize,
                fontWeight: FontWeight.w500),
            
            // **** Info ****
            display4: TextStyle(
                color: Colors.grey[600],
                fontSize: fontSize - 1,
                fontWeight: FontWeight.bold)));

    return themeData;
  }

   static ThemeData theme(String key, double fontSize, String fontFamily) {
     Map<String, ThemeData> themeDatas = {'Klasik': AppTheme.light(fontSize, fontFamily), 'Karanlık': AppTheme.dark(fontSize, fontFamily), 'Portakal': AppTheme.orange(fontSize, fontFamily), 'Gökyüzü': AppTheme.sky(fontSize, fontFamily), 'Sıcak': AppTheme.hot(fontSize, fontFamily)};
     return themeDatas[key];
   }

}
