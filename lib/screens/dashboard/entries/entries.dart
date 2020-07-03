import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salveSeuPorquinho/models/forecast_model.dart';
import 'package:salveSeuPorquinho/models/wrapper_model.dart';
import 'package:salveSeuPorquinho/screens/dashboard/entries/filter_dto.dart';
import 'package:salveSeuPorquinho/services/business/forecast_business.dart';
import 'package:salveSeuPorquinho/services/database/forecast_dao.dart';
import 'package:salveSeuPorquinho/services/database/wrapper_dao.dart';

import 'header.dart';

class EntriesScreen extends StatefulWidget {
  @override
  _EntriesScreenState createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<EntriesScreen> {
  FilterDto _filter = FilterDto(DateTime.now());
  List<WrapperModel> _wrappers = [];

  WrapperDAO wrapperDao = new WrapperDAO();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData(_filter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Header(_filter, _wrappers, (filter) => _loadData(filter)),
        ],
      ),
    );
  }

  _loadData(FilterDto _filter) async {
    ForecastModel _forecast =
        await ForecastBusiness.loadIdForecastByDateOrLast(_filter.monthYear);
    List<WrapperModel> _wrappers =
        await wrapperDao.findByForecast(_forecast.id);
    setState(() {
      print('oi');
      print(_forecast.id);
      print(_wrappers);
      this._wrappers = _wrappers;
      this._filter = this._filter.copyWith(
            monthYear: DateTime(
              _forecast.year,
              _forecast.month,
              1,
            ),
          );
    });
  }
}
