import 'package:flutter/material.dart';
import 'package:salveSeuPorquinho/screens/configurations/crud_header_buttons.dart';
import 'package:salveSeuPorquinho/screens/configurations/crud_body.dart';

class Configurations extends StatefulWidget {
  @override
  _ConfigurationsState createState() => _ConfigurationsState();
}

class _ConfigurationsState extends State<Configurations> {
  static const _HEADER_FORECAST_TEXT = "Configurar Previsões";
  static const _HEADER_CATEGORIES_TEXT = "Configurar Categorias";
  static const _HEADER_PAYMENT_METHODS = "Formas de Pagamento";

  String _headerText = _HEADER_FORECAST_TEXT;
  String _selectedTab = CrudHeaderButtons.FORECAST_TEXT;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(_headerText),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
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
      ),
    );
  }

  _handleTabSelected(String tabName) {
    setState(() {
      if (tabName == CrudHeaderButtons.FORECAST_TEXT) {
        this._headerText = _HEADER_FORECAST_TEXT;
      } else if (tabName == CrudHeaderButtons.CATEGORIES_TEXT) {
        this._headerText = _HEADER_CATEGORIES_TEXT;
      } else {
        this._headerText = _HEADER_PAYMENT_METHODS;
      }

      this._selectedTab = tabName;
    });
  }
}
