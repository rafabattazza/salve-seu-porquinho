import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:salveSeuPorquinho/components/info_dialog.dart';
import 'package:salveSeuPorquinho/models/category_model.dart';
import 'package:salveSeuPorquinho/models/forecast_model.dart';
import 'package:salveSeuPorquinho/services/database/forecast_dao.dart';
import 'package:salveSeuPorquinho/services/database/start_db_dao.dart';
import 'package:salveSeuPorquinho/services/database/wrapper_dao.dart';

class ForecastBusiness {
  static Future<ForecastModel> loadIdForecastByDateOrLast(
    DateTime date,
  ) async {
    final ForecastDAO _forecastDao = ForecastDAO();
    ForecastModel _forecast =
        await _forecastDao.findByMonthAndYear(date.month, date.year);

    if (_forecast == null) {
      _forecast = await _forecastDao.findLast();
    }

    return _forecast;
  }

  static Future<ForecastModel> loadOrCreateForecast(
    BuildContext context,
    DateTime date,
  ) async {
    final ForecastDAO _forecastDao = ForecastDAO();
    final WrapperDAO _wrapperDao = WrapperDAO();

    ForecastModel _forecast =
        await _forecastDao.findByMonthAndYear(date.month, date.year);
    if (_forecast == null) {
      _forecast = await _forecastDao.findLast();
      if (_forecast != null) {
        _forecast = await _copyForecast(
            context, _forecast, date, _forecastDao, _wrapperDao);
      }
    }

    if (_forecast == null) {
      await new StartDbDao().createDefaultPrevision();
      _forecast = await _forecastDao.findByMonthAndYear(date.month, date.year);
    }

    List<CategoryModel> _categories =
        await _wrapperDao.findByForecastGroupedByCategory(_forecast.id);

    _forecast.categories = _categories;

    return _forecast;
  }

  static Future<ForecastModel> _copyForecast(
    BuildContext context,
    ForecastModel _forecast,
    DateTime date,
    ForecastDAO _forecastDao,
    WrapperDAO _wrapperDao,
  ) async {
    DateFormat dateFormat = new DateFormat("MM/yyyy");
    //Creating from the last forecast
    int lastId = _forecast.id;
    DateTime lastDate = DateTime.parse(
        "${_forecast.year.toString().padLeft(4, '0')}${_forecast.month.toString().padLeft(2, '0')}01");
    _forecast.id = null;
    _forecast.month = date.month;
    _forecast.year = date.year;
    await _forecastDao.persist(_forecast);
    await _wrapperDao.duplicateForecast(lastId, _forecast.id);

    const String _COPY_FORECAST_MSG =
        "Não foram localizadas previsões para '{1}', por isso o sistema criou novas com base nas previsões de '{2}'.";
    await InfoDialog.showInfo(
        context,
        _COPY_FORECAST_MSG
            .replaceAll("{1}", dateFormat.format(date))
            .replaceAll("{2}", dateFormat.format(lastDate)));
    return _forecast;
  }
}
