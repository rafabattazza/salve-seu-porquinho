import 'package:flutter/material.dart';

class InfoDialog {
  static Future<void> showInfo(BuildContext context, String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Salve Seu Porquinho'),
          content: SingleChildScrollView(child: Text(msg)),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
