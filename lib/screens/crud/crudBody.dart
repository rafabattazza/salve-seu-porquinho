import 'dart:developer';

import 'package:flutter/material.dart';

class CrudBody extends StatefulWidget {
  final _CrudBodyState state = _CrudBodyState();

  @override
  _CrudBodyState createState() => state;

  updateTab(String tabName) {
    state._updateTab(tabName);
  }
}

class _CrudBodyState extends State<CrudBody> {
  String _selectedTabName = "Previsões";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text("AsssA")
    );
  }

  _updateTab(String tabName){
    setState(() {
      this._selectedTabName = tabName;
    });
  }
}