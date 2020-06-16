import 'package:flutter/material.dart';
import 'package:salveSeuPorquinho/screens/crud/crudHeaderButtons.dart';

import 'crudBody.dart';

class Configurations extends StatelessWidget {
  final _headerText = "Configurar Categorias";
  final crudBody = CrudBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(_headerText),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.maxFinite,
            height: 133,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF5D57EA), Color(0xFF9647DB)]),
            ),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  CrudHeaderButtons((tabName) => this._handleTabSelected(tabName)),
                ],
              ),
            ),
          ),
          crudBody
        ],
      ),
    );
  }
  _handleTabSelected (String tabName) {
    crudBody.updateTab(tabName);
  }
}
