import 'package:flutter/material.dart';

class ThemeUtils {
  static ThemeData createDarkTheme() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Color(0xFF22222A),
    );
  }

  static const TextStyle thinText = TextStyle(
    fontWeight: FontWeight.w300,
  );

  static final InputDecoration inputDecoration = InputDecoration(
    filled: true,
    contentPadding: new EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
    border: new OutlineInputBorder(
      borderRadius: new BorderRadius.circular(12.0),
    ),
  );
}
