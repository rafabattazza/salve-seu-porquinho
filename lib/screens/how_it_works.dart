import 'package:flutter/material.dart';

import 'dashboard/dashboard.dart';

class HowItWorks extends StatelessWidget {
  static const HOW_WORKS_TEXT = "Como Funciona?";
  static const DESCRIPTION_TEXT =
      "O SalveSeuPorquinho utiliza a estratégia dos envelopes pra você economizar seu dinheiro.";

  static const FIRST_STEP = "1º Informe o quanto você recebe por mês";
  static const SECOND_STEP =
      "2º Crie os envelopes com suas previsões de despesas para o mês";
  static const THIRD_STEP =
      "3º Lance suas despesas em cada envelope durante o mês até atingir o limite mensal de cada evelope";
  static const FOURTH_STEP =
      "4º Ajuste os envelopes para o mês seguinte e assim vá ajustando suas despesas";

  static const LOGIN_BUTTON_TEXT = "Entrar";

  final _textStyle = TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFFB6E7E3), const Color(0xFF26B6AC)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(HOW_WORKS_TEXT),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Text(
                  DESCRIPTION_TEXT,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF22222A), fontSize: 24),
                ),
              ),
              Image(
                image: AssetImage("assets/images/envelope.png"),
                fit: BoxFit.cover,
                width: double.maxFinite,
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        FIRST_STEP,
                        style: _textStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Text(
                        SECOND_STEP,
                        style: _textStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Text(
                        THIRD_STEP,
                        style: _textStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Text(
                        FOURTH_STEP,
                        style: _textStyle,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 25),
                      width: double.maxFinite,
                      child: RaisedButton(
                        color: Colors.black,
                        child: Text(LOGIN_BUTTON_TEXT),
                        onPressed: () => _handlerBtnLogInClick(context),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handlerBtnLogInClick(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return DashboardScreen();
    }));
  }
}
