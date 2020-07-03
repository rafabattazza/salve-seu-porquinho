import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salveSeuPorquinho/models/transac_model.dart';
import 'package:salveSeuPorquinho/models/wrapper_model.dart';
import 'package:salveSeuPorquinho/screens/dashboard/components/date_select.dart';
import 'package:salveSeuPorquinho/screens/dashboard/entries/filter_dto.dart';
import 'package:salveSeuPorquinho/screens/dashboard/entries/form_entry.dart';

class Header extends StatelessWidget {
  static const _NEW_TEXT = "Novo";
  static const _WRAPPER_FILTER_TEXT = "Filtrar por envelope";

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
          height: 128,
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: _WRAPPER_FILTER_TEXT,
                        ),
                        value: _filter.wrapperId,
                        items: _getWrapperMenuItens(),
                        onChanged: (wId) => _wrapperIdChange(wId),
                      ),
                    ),
                    if (this._filter.wrapperId != null)
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () => _wrapperIdChange(null),
                      )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DateSelect(_filter.monthYear, _dateChange),
                    RaisedButton(
                      color: Color(0xFF560FE5),
                      onPressed: () => _onBtnNewAction(context),
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
    if (this.wrappers == null || this.wrappers.length == 0) return [];
    var res = this
        .wrappers
        .map((e) => new DropdownMenuItem(
              child: Text(e.name),
              value: e.id,
            ))
        .toList();

    return res;
  }

  _dateChange(DateTime date) {
    FilterDto _filter = this._filter.copyWith(monthYear: date);
    _filter.wrapperId = null;
    onFilterChange(_filter);
  }

  _wrapperIdChange(int wrapperId) {
    FilterDto _filter = this._filter.copyWith(wrapperId: wrapperId);
    if (wrapperId == null) _filter.wrapperId = null;
    onFilterChange(_filter);
  }

  _onBtnNewAction(BuildContext context) async {
    final saved = await Navigator.push(context, MaterialPageRoute(builder: (_) {
          return FormEntry(
              TransacModel(), this.wrappers[0].forecast.id, _filter.wrapperId);
        })) ??
        false;
    if (saved) onFilterChange(_filter);
  }
}
