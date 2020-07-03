import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salveSeuPorquinho/models/wrapper_model.dart';
import 'package:salveSeuPorquinho/screens/dashboard/components/date_select.dart';
import 'package:salveSeuPorquinho/screens/dashboard/entries/filter_dto.dart';

class Header extends StatelessWidget {
  static const _NEW_TEXT = "Novo";

  final FilterDto _filter;
  final List<WrapperModel> wrappers;
  final Function(FilterDto) onFilterChange;
  const Header(
    this._filter,
    this.wrappers,
    this.onFilterChange, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.maxFinite,
          height: 107,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF5D57EA), Color(0xFF9647DB)]),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    DropdownButton<int>(
                        items: _getWrapperMenuItens(),
                        onChanged: (e) => print(e)),
                    // TextField()
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DateSelect(_filter.monthYear, _dateChange),
                    RaisedButton(
                      color: Color(0xFF560FE5),
                      onPressed: () => print("a"),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.add),
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Text(_NEW_TEXT),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<int>> _getWrapperMenuItens() {
    print('entrou');
    if (this.wrappers == null || this.wrappers.length == 0) return [];
    var res = this
        .wrappers
        .map((e) => new DropdownMenuItem(
              child: Text(e.name),
              value: e.id,
            ))
        .toList();
    print('aqui');
    print(res);

    return res;
  }

  _dateChange(DateTime date) {
    onFilterChange(this._filter.copyWith(monthYear: date));
  }

  _wrapperIdChange(int wrapperId) {
    onFilterChange(this._filter.copyWith(wrapperId: wrapperId));
  }

  _queryChange(String query) {
    onFilterChange(this._filter.copyWith(query: query));
  }
}
