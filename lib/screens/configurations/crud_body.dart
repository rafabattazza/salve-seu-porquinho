import 'package:flutter/material.dart';
import 'package:salveSeuPorquinho/screens/configurations/crud_header_buttons.dart';
import 'form_category.dart';
import 'form_forecast.dart';

class CrudBody extends StatelessWidget {
  final String _selectedTab;

  CrudBody(this._selectedTab);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: _createForm(),
    );
  }

  Widget _createForm() {
    if (this._selectedTab == CrudHeaderButtons.FORECAST_TEXT) {
      return FormForecast();
    } else {
      return FormCategories();
    }
  }
}
