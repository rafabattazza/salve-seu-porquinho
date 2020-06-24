import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FormPrevision extends StatefulWidget {
  FormPrevision({Key key}) : super(key: key);

  @override
  _FormPrevisionState createState() => _FormPrevisionState();
}

class _FormPrevisionState extends State<FormPrevision> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextField(
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.blueAccent,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            prefixIcon: Icon(Icons.people),
            hintText: "Enter Your Name",
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent, width: 32.0),
                borderRadius: BorderRadius.circular(25.0)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 32.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
      ],
    );
  }
}
