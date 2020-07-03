import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_strip/month_picker_strip.dart';

// ignore: must_be_immutable
class DateSelect extends StatelessWidget {
  static const _SELECT_MONTH_TEXT = 'Selecione o mês e o ano';
  final DateFormat _format = new DateFormat("MMMM yyyy");

  final DateTime monthYear;
  final Function(DateTime) onDateChange;
  DateTime _lastSelectedDate;

  DateSelect(
    this.monthYear,
    this.onDateChange, {
    Key key,
  }) : super(key: key) {
    this._lastSelectedDate = this.monthYear;
  }

  BuildContext context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return InkWell(
      child: Row(
        children: <Widget>[
          Icon(Icons.date_range),
          Padding(padding: EdgeInsets.only(left: 16)),
          Text(_format.format(monthYear)),
        ],
      ),
      onTap: () => _showMonthSelect(context),
    );
  }

  _showMonthSelect(context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_SELECT_MONTH_TEXT),
          content: Container(
            width: double.maxFinite,
            height: 40,
            child: MonthStrip(
              format: 'MMM/yyyy',
              from: new DateTime(2020, 1),
              to: new DateTime(2050, 12),
              initialMonth: monthYear,
              height: 48.0,
              viewportFraction: 0.35,
              onMonthChanged: (date) async {
                await _setDate(date);
              },
              normalTextStyle: TextStyle(color: Colors.white),
              selectedTextStyle: TextStyle(color: Colors.green),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: _onOkButtonClick,
            ),
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _setDate(DateTime date) {
    this._lastSelectedDate = date;
  }

  _onOkButtonClick() {
    Navigator.of(context).pop();
    onDateChange(this._lastSelectedDate);
  }
}
