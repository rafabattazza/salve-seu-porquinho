import 'package:flutter/material.dart';

import 'dashboard.dart';

class HowItWorks extends StatelessWidget {
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
          title: Text("Como Funciona?"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Text(
                  "O SalveSeuPorquinho utiliza a estratégia dos envelopes pra você economizar seu dinheiro.",
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
                        "1º Informe o quanto você recebe por mês",
                        style: _textStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Text(
                        "2º Crie os envelopes com suas previsões de despesas para o mês",
                        style: _textStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Text(
                        "3º Lance suas despesas em cada envelope durante o mês até atingir o limite mensal de cada evelope",
                        style: _textStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Text(
                        "4º Ajuste os envelopes para o mês seguinte e assim vá ajustando suas despesas",
                        style: _textStyle,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 25),
                      width: double.maxFinite,
                      child: RaisedButton(
                        color: Colors.black,
                        child: Text("Entrar"),
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
