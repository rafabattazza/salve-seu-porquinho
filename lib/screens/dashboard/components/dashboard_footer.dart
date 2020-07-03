import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salveSeuPorquinho/screens/welcome.dart';
import 'package:salveSeuPorquinho/utils/theme_utils.dart';

class DashboardFooter extends StatelessWidget {
  static const _FORECAST_TEXT = "Previsões";
  static const _VALUES_TEXT = "Lançamentos";
  static const _REPORTS_TEXT = "Relatórios";
  static const _EXIT_TEXT = "Sair";

  final int selectedTab;
  final Function(int) onSelectedTab;
  const DashboardFooter(
    this.selectedTab,
    this.onSelectedTab, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xFF22222A)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _createButton(0, _FORECAST_TEXT, Icons.access_time, context),
          _createButton(1, _VALUES_TEXT, Icons.credit_card, context),
          _createButton(2, _REPORTS_TEXT, Icons.timeline, context),
          _createButton(3, _EXIT_TEXT, Icons.power_settings_new, context),
        ],
      ),
    );
  }

  Widget _createButton(final int index, final String _text,
      final IconData iconData, final BuildContext context) {
    bool selected = index == selectedTab;
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF22222A),
          border: selected
              ? Border(top: BorderSide(width: 3.0, color: Color(0xFF9647DB)))
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: <Widget>[
              Icon(
                iconData,
                size: 16,
                color: index == 3 ? Colors.red : null,
              ),
              Padding(padding: EdgeInsets.only(top: 4.0)),
              Text(
                _text,
                style: ThemeUtils.thinText.copyWith(
                  fontSize: 12,
                  color: index == 3 ? Colors.red : null,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () => _onButtonTap(index, context),
    );
  }

  _onButtonTap(index, context) {
    if (index == 3) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return WelcomeScreen();
      }));
    } else {
      if (index != selectedTab) {
        onSelectedTab(index);
      }
    }
  }
}
