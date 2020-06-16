import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salveSeuPorquinho/screens/crud/Configurations.dart';
import 'package:salveSeuPorquinho/screens/howItWorks.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _background = AssetImage("assets/images/bg.jpg");

    final _titleText = "SalveSeuPorquinho";
    final _descriptionText =
        "Ajudamos você a não quebrar seu cofrinho no final do mês!!!";
    final _accessButtonText = "Entrar";
    final _howWorksButtonText = "Ver como funciona";

    final _titleStyle = TextStyle(
      color: Color(0xFF804541),
      fontSize: 32,
    );
    final _descriptionStyle = TextStyle(
      color: Color(0xFF403434),
      fontSize: 24,
    );
    final _accessButtonStyle = TextStyle(fontSize: 20);
    final _howWorksButtonStyle = TextStyle(
      fontSize: 20,
      decoration: TextDecoration.underline,
      color: Color(0xFF804541),
    );

    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: _background,
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
                    _titleText,
                    style: _titleStyle,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 350, 8, 32),
                  child: Text(
                    _descriptionText,
                    textAlign: TextAlign.center,
                    style: _descriptionStyle,
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
                        _accessButtonText,
                        style: _accessButtonStyle,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: FlatButton(
                    onPressed: () => _handleBtnHowItWorkClick(context),
                    child: Text(
                      _howWorksButtonText,
                      style: _howWorksButtonStyle,
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

  void _handleBtnLogInClick(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return Configurations();
    }));
  }

  void _handleBtnHowItWorkClick(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return HowItWorks();
    }));
  }
}