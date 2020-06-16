import 'package:flutter/material.dart';

class CrudHeaderButtons extends StatefulWidget {
  final Function _navigationHandler;
  CrudHeaderButtons(this._navigationHandler);
  @override
  _CrudHeaderButtonsState createState() {
    return _CrudHeaderButtonsState();
  }
}

class _CrudHeaderButtonsState extends State<CrudHeaderButtons> {
  final _forecastText = "Previsões";
  final _wrapperText = "Envelopes";
  final _categoriesText = "Categorias";
  String _selectedButtom;

  _CrudHeaderButtonsState(){
    this._selectedButtom = _forecastText;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        NavigationButton(_forecastText, Icons.access_time,
            _selectedButtom == _forecastText, _handlerClick),
        NavigationButton(_wrapperText, Icons.mail_outline,
            _selectedButtom == _wrapperText, _handlerClick),
        NavigationButton(_categoriesText, Icons.format_list_bulleted,
            _selectedButtom == _categoriesText, _handlerClick)
      ],
    );
  }

  _handlerClick(String selectedText) {
    setState(() {
      this._selectedButtom = selectedText;
      widget._navigationHandler(this._selectedButtom);
    });
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
            Padding(padding: EdgeInsets.only(top: 4)),
            Text(this.textData)
          ],
        ),
      ),
      onTap: () => this.onCLick(this.textData),
    );
  }
}
