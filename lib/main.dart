import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:salveSeuPorquinho/screens/welcome.dart';
import 'package:salveSeuPorquinho/utils/theme_utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(new SalveSeuPorquinho());
}

void setErrorBuilder() {
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(
              "Unexpected error. See console for details.",
              style: ThemeUtils.bigText.copyWith(color: Colors.redAccent),
            ),
          ),
          Text(errorDetails.stack.toString())
        ],
      ),
    );
  };
}

class SalveSeuPorquinho extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (BuildContext context, Widget widget) {
        setErrorBuilder();
        return widget;
      },
      title: 'SalveSeuPorquinho',
      theme: ThemeUtils.createDarkTheme(),
      home: WelcomeScreen(),
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [
        const Locale('pt', 'BR'),
      ],
    );
  }
}
