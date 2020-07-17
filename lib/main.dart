import 'package:flutter/material.dart';
import 'package:salveSeuPorquinho/screens/welcome.dart';
import 'package:salveSeuPorquinho/utils/theme_utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(new SalveSeuPorquinho());
}

class SalveSeuPorquinho extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SalveSeuPorquinho',
      theme: ThemeUtils.createDarkTheme(),
      home: WelcomeScreen(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('pt', 'BR'),
      ],
    );
  }
}
