import 'package:flutter/material.dart';

class QuestionDialog {
  static Future<bool> showQuestion(BuildContext context, String msg) async {
    const String _OK_BUTTON_TEXT = "SIM";
    const String _CANCEL_BUTTON_TEXT = "NÃO";

    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Salve Seu Porquinho'),
          content: SingleChildScrollView(child: Text(msg)),
          actions: <Widget>[
            FlatButton(
              child: Text(_OK_BUTTON_TEXT),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            FlatButton(
              child: Text(_CANCEL_BUTTON_TEXT),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }
}
