import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_strip/month_picker_strip.dart';

class Header extends StatelessWidget {
  static const String _DATE_LABEL_TEXT = "Selecione o mês e ano da relatório";

  final Function(DateTime) onFilterChange;
  const Header(
    this.onFilterChange, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.maxFinite,
          height: 150,
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF5D57EA), Color(0xFF9647DB)]),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _DATE_LABEL_TEXT,
                    ),
                    new MonthStrip(
                      format: 'MMM yyyy',
                      from: new DateTime(2016, 4),
                      to: new DateTime(2025, 5),
                      initialMonth: DateTime.now(),
                      height: 48.0,
                      viewportFraction: 0.25,
                      onMonthChanged: (date) async {
                        await _loadOrCreatePrevision(date);
                      },
                      normalTextStyle: TextStyle(color: Colors.white),
                      selectedTextStyle: TextStyle(color: Colors.green),
                    ),
                    Divider(
                      color: Colors.white54,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _loadOrCreatePrevision(DateTime date) async {
    this.onFilterChange(date);
  }
}
