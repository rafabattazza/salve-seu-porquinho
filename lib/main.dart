import 'package:flutter/material.dart';
import 'package:salveSeuPorquinho/screens/welcome.dart';

void main() {
  runApp(new SalveSeuPorquinho());
}

class SalveSeuPorquinho extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SalveSeuPorquinho',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF22222A)
      ),
      home: WelcomeScreen(),
    );
  }
}
