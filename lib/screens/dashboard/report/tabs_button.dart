import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabsButton extends StatelessWidget {
  static const _WRAPPER_TEXT = "Envelopes";
  static const _CATEGORY_TEXT = "Formas";

  final int selectedTab;
  final Function(int) onSelectedTab;

  const TabsButton(
    this.selectedTab,
    this.onSelectedTab, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _createButton(0, _WRAPPER_TEXT, Icons.email),
          Padding(padding: EdgeInsets.only(left: 32)),
          _createButton(1, _CATEGORY_TEXT, Icons.bubble_chart),
        ],
      ),
    );
  }

  Widget _createButton(
    final int index,
    final String _text,
    final IconData iconData,
  ) {
    bool selected = index == selectedTab;
    return InkWell(
      child: Container(
        width: 107,
        height: 63,
        decoration: BoxDecoration(
          color: Color(0xFF12121A),
          border: selected ? Border(bottom: BorderSide(width: 3.0, color: Colors.lightBlue.shade50)) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Icon(
                iconData,
                size: 18,
              ),
              Padding(padding: EdgeInsets.only(top: 8)),
              Text(_text),
            ],
          ),
        ),
      ),
      onTap: () => onSelectedTab(index),
    );
  }
}
