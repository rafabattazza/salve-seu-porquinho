import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salveSeuPorquinho/screens/configurations/index.dart';
import 'package:salveSeuPorquinho/screens/dashboard/date_select.dart';
import 'package:salveSeuPorquinho/utils/theme_utils.dart';
import 'package:salveSeuPorquinho/utils/utils.dart';

class Header extends StatelessWidget {
  static const _LABEL_TEXT = "Saldo dos envelopes";

  final double total;
  final DateTime monthYear;
  final Function(DateTime) onDateChange;
  const Header(
    this.total,
    this.monthYear,
    this.onDateChange, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 205,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF5D57EA), Color(0xFF9647DB)]),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Container(
                        width: 45,
                        height: 30,
                        decoration: BoxDecoration(color: Color(0xFF42424A)),
                        child: Center(
                          child: Icon(Icons.attach_money,
                              color: Colors.greenAccent),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return Configurations();
                    }));
                  },
                  child: Icon(Icons.settings),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              Utils.numberFormat.format(total),
              style: ThemeUtils.ultraThinText.copyWith(fontSize: 36),
            ),
          ),
          Text(_LABEL_TEXT, style: ThemeUtils.ultraThinText),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                DateSelect(this.monthYear, onDateChange),
              ],
            ),
          )
        ],
      ),
    );
  }
}
