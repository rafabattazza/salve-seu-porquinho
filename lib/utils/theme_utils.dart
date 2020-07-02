import 'package:flutter/material.dart';

class ThemeUtils {
  static ThemeData createDarkTheme() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Color(0xFF22222A),
    );
  }

  static const TextStyle ultraThinText = TextStyle(
    fontWeight: FontWeight.w100,
  );

  static const TextStyle thinText = TextStyle(
    fontWeight: FontWeight.w300,
  );

  static const TextStyle strongText = TextStyle(
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bigText = TextStyle(
      fontWeight: FontWeight.w500, fontSize: 22, color: Colors.white54);

  static final InputDecoration inputDecoration = InputDecoration(
    filled: true,
    contentPadding: new EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
    border: new OutlineInputBorder(
      borderRadius: new BorderRadius.circular(12.0),
    ),
  );
}
