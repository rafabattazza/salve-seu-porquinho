import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salveSeuPorquinho/screens/how_it_works.dart';
import 'package:salveSeuPorquinho/services/database_service.dart';

import 'dashboard/dashboard.dart';

class WelcomeScreen extends StatelessWidget {
  static const BACKGROUND = AssetImage("assets/images/bg.jpg");
  static const TITLE_TEXT = "SalveSeuPorquinho";
  static const DESCRIPTION_TEXT =
      "Ajudamos você a não quebrar seu cofrinho no final do mês!!!";
  static const ACCESS_BUTTON_TEXT = "Entrar";
  static const HOW_WORKS_BUTTON_TEXT = "Ver como funciona";

  static const TITLE_STYLE = TextStyle(
    color: Color(0xFF804541),
    fontSize: 32,
  );
  static const DESCRIPTION_STYLE = TextStyle(
    color: Color(0xFF403434),
    fontSize: 24,
  );
  static const ACCESS_BUTTON_STYLE = TextStyle(fontSize: 20);
  static const HOW_WORKS_BUTTON_STYLE = TextStyle(
    fontSize: 20,
    decoration: TextDecoration.underline,
    color: Color(0xFF804541),
  );

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).size.height / 2;

    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: BACKGROUND,
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    TITLE_TEXT,
                    style: TITLE_STYLE,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8, paddingTop, 8, 32),
                  child: Text(
                    DESCRIPTION_TEXT,
                    textAlign: TextAlign.center,
                    style: DESCRIPTION_STYLE,
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: RaisedButton(
                      color: Color(0xAA14B390),
                      onPressed: () => _handleBtnLogInClick(context),
                      child: Text(
                        ACCESS_BUTTON_TEXT,
                        style: ACCESS_BUTTON_STYLE,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: FlatButton(
                    onPressed: () => _handleBtnHowItWorkClick(context),
                    child: Text(
                      HOW_WORKS_BUTTON_TEXT,
                      style: HOW_WORKS_BUTTON_STYLE,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleBtnLogInClick(BuildContext context) async {
    await new DataBaseService().startDb();

    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return DashboardScreen();
    }));
  }

  void _handleBtnHowItWorkClick(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return HowItWorks();
    }));
  }
}
