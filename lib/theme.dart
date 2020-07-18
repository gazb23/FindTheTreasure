import 'package:flutter/material.dart';

class MaterialTheme {
  static const orange = Color(0xFFFEAF3F);
  static const red = Color(0xFFFF684D);
  static const blue = Color(0xFF0CC7D3);

  // Theme for the app
  static ThemeData buildThemeData() {
    return ThemeData(
      buttonTheme: ButtonThemeData(
        height: 45.0,
      ),
      dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          titleTextStyle: TextStyle(
              color: Colors.black87,
              fontSize: 22.0,
              fontWeight: FontWeight.w500),
          contentTextStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 18.0,
          )),
      fontFamily: 'quicksand',
      // Define the text theme for the app
      textTheme: TextTheme(
          headline5: TextStyle(
              color: Colors.black54, fontSize: 28, fontWeight: FontWeight.bold),
          bodyText2: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade500,
              fontFamily: 'quicksand'),
              bodyText1: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontFamily: 'quicksand'),
          button: TextStyle(
            fontSize: 15.0,
          )),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[500])),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: MaterialTheme.orange)),
        labelStyle: TextStyle(color: Colors.grey[500]),
      ),
      backgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        actionsIconTheme: IconThemeData(
          color: Colors.black87
        ),
          color: Colors.white,
          textTheme: TextTheme(
              headline5: TextStyle(fontFamily: 'quicksand', fontSize: 20, color: Colors.black87))),
              iconTheme: IconThemeData(
                color: Colors.black87

              )
    );
  }
}