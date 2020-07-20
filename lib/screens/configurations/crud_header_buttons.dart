import 'package:flutter/material.dart';

class CrudHeaderButtons extends StatelessWidget {
  static const FORECAST_TEXT = "Previsões";
  static const CATEGORIES_TEXT = "Categorias";

  final String _selectedTab;
  final Function _navigationHandler;

  CrudHeaderButtons(this._selectedTab, this._navigationHandler);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 134,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF5D57EA), Color(0xFF9647DB)]),
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            NavigationButton(FORECAST_TEXT, Icons.access_time,
                _selectedTab == FORECAST_TEXT, _handlerClick),
            SizedBox(
              width: 20,
            ),

            NavigationButton(CATEGORIES_TEXT, Icons.format_list_bulleted,
                _selectedTab == CATEGORIES_TEXT, _handlerClick)
          ],
        ),
      ),
    );
  }

  _handlerClick(String selectedText) {
    _navigationHandler(selectedText);
  }
}

class NavigationButton extends StatelessWidget {
  final String textData;
  final IconData iconData;
  final bool selected;
  final Function onCLick;
  NavigationButton(
    this.textData,
    this.iconData,
    this.selected,
    this.onCLick, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 107,
        height: 53,
        decoration: BoxDecoration(
          color: const Color(0xFF22222A),
          border: this.selected
              ? Border(
                  bottom: selected
                      ? BorderSide(width: 3.0, color: Colors.lightBlue.shade50)
                      : null)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              size: 22.0,
            ),
            const Padding(padding: EdgeInsets.only(top: 4)),
            Text(this.textData)
          ],
        ),
      ),
      onTap: () => this.onCLick(this.textData),
    );
  }
}
