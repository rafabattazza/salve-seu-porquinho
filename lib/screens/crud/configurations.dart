import 'package:flutter/material.dart';
import 'package:salveSeuPorquinho/screens/crud/crud_header_buttons.dart';
import 'package:salveSeuPorquinho/screens/crud/crud_body.dart';

class Configurations extends StatefulWidget {
  @override
  _ConfigurationsState createState() => _ConfigurationsState();
}

class _ConfigurationsState extends State<Configurations> {
  static const HEADER_FORECAST_TEXT = "Configurar Previsões";
  static const HEADER_CATEGORIES_TEXT = "Configurar Categorias";

  String _headerText = HEADER_FORECAST_TEXT;
  String _selectedTab = CrudHeaderButtons.FORECAST_TEXT;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CrudHeaderButtons(_selectedTab, _handleTabSelected),
          Expanded(
            child: SingleChildScrollView(
              child: CrudBody(_selectedTab),
            ),
          ),
        ],
      ),
    );
  }

  _handleTabSelected(String tabName) {
    setState(() {
      if (tabName == CrudHeaderButtons.FORECAST_TEXT) {
        this._headerText = HEADER_FORECAST_TEXT;
      } else {
        this._headerText = HEADER_CATEGORIES_TEXT;
      }

      this._selectedTab = tabName;
    });
  }
}
