import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:salveSeuPorquinho/components/info_dialog.dart';
import 'package:salveSeuPorquinho/models/category_model.dart';
import 'package:salveSeuPorquinho/models/forecast_model.dart';
import 'package:salveSeuPorquinho/models/wrapper_model.dart';
import 'package:salveSeuPorquinho/services/database_service.dart';
import 'package:salveSeuPorquinho/services/wrapper_service.dart';
import 'package:sqflite/sqflite.dart';

class ForecastService {
  static Future<ForecastModel> loadIdForecastByDateOrLast(
    DateTime date,
  ) async {
    final ForecastService _forecastDao = ForecastService();
    ForecastModel _forecast =
        await _forecastDao.findByMonthAndYear(date.month, date.year);

    if (_forecast == null) {
      _forecast = await _forecastDao.findLast();
    }

    return _forecast;
  }

  Future<ForecastModel> loadOrCreateForecast(
    BuildContext context,
    DateTime date,
  ) async {
    final ForecastService _forecastDao = ForecastService();
    final WrapperService _wrapperService = WrapperService();

    ForecastModel _forecast =
        await _forecastDao.findByMonthAndYear(date.month, date.year);
    if (_forecast == null) {
      _forecast = await _forecastDao.findLast();
      if (_forecast != null) {
        _forecast = await _copyForecast(
            context, _forecast, date, _forecastDao, _wrapperService);
      }
    }

    if (_forecast == null) {
      await _forecastDao.createDefaultForecast();
      _forecast = await _forecastDao.findByMonthAndYear(date.month, date.year);
    }

    List<CategoryModel> _categories =
        await _wrapperService.findByForecastGroupedByCategory(_forecast.id);

    _forecast.categories = _categories;

    return _forecast;
  }

  Future<ForecastModel> _copyForecast(
    BuildContext context,
    ForecastModel _forecast,
    DateTime date,
    ForecastService _forecastDao,
    WrapperService _wrapperDao,
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

  Future<ForecastModel> findWithTransactionsValue(final int forecastId) async {
    final db = await DataBaseService().database;

    List<Map<String, dynamic>> resCategory = await db.rawQuery(
        " SELECT for_id, for_month, for_year, for_invoice, cat_id, cat_name, cat_percent, wra_id, wra_name, wra_budget, COALESCE(SUM(tra_value), 0) as sumTransactions"
        " FROM Wrapper "
        " INNER JOIN Forecast ON for_id = wra_forecast"
        " INNER JOIN Category ON cat_id = wra_category"
        " LEFT JOIN Transac ON wra_id = tra_wrapper"
        " WHERE wra_forecast = ?"
        " GROUP BY for_id, for_month, for_year, for_invoice, cat_id, cat_name, cat_percent, wra_id, wra_name, wra_budget"
        " ORDER BY cat_percent DESC, cat_name, wra_budget DESC",
        [forecastId]);

    if (resCategory.isEmpty) return null;

    List<CategoryModel> categories = [];
    for (Map<String, dynamic> mapCategory in resCategory) {
      CategoryModel category = CategoryModel.fromMap(mapCategory);
      if (categories.length == 0 || categories.last.id != category.id) {
        categories.add(category);
      }
      category = categories.last;

      WrapperModel wrapper = WrapperModel.fromMap(mapCategory);
      wrapper.sumTransactions = mapCategory['sumTransactions'] + .0;

      category.groupedWrappers.add(wrapper);
    }

    ForecastModel forecast = ForecastModel.fromMap(resCategory[0]);
    forecast.categories = categories;

    return forecast;
  }

  persist(ForecastModel forecast) async {
    final db = await DataBaseService().database;

    if (forecast.id != null) {
      await db.update("Forecast", forecast.toMap(),
          where: "for_id = ?", whereArgs: [forecast.id]);
    } else {
      int insertedId = await db.insert("Forecast", forecast.toMap());
      forecast.id = insertedId;
    }
  }

  Future<ForecastModel> findByMonthAndYear(int month, int year) async {
    final db = await DataBaseService().database;
    List<Map<String, dynamic>> res = await db.rawQuery(
        " SELECT *"
        " FROM Forecast"
        " WHERE for_month = ? AND for_year = ?",
        [month, year]);

    return res.isNotEmpty ? ForecastModel.fromMap(res[0]) : null;
  }

  Future<ForecastModel> findLast() async {
    final db = await DataBaseService().database;
    List<Map<String, dynamic>> res = await db.rawQuery(" SELECT *"
        " FROM Forecast"
        " ORDER BY for_year DESC, for_month DESC"
        " LIMIT 1");

    return res.isNotEmpty ? ForecastModel.fromMap(res[0]) : null;
  }

  Future<void> createDefaultForecast() async {
    final db = await DataBaseService().database;
    final int forecastId = await db.insert(
        "Forecast",
        ForecastModel.all(
                null, DateTime.now().month, DateTime.now().year, 2000.0)
            .toMap());

    Batch batch = db.batch();
    batch.insert(
        "Wrapper",
        WrapperModel.all(null, ForecastModel.id(forecastId),
                CategoryModel.id(1), "Mercado", 450.0)
            .toMap());
    batch.insert(
        "Wrapper",
        WrapperModel.all(null, ForecastModel.id(forecastId),
                CategoryModel.id(1), "Lazer", 150.0)
            .toMap());
    batch.insert(
        "Wrapper",
        WrapperModel.all(null, ForecastModel.id(forecastId),
                CategoryModel.id(1), "Roupas", 100.0)
            .toMap());
    batch.insert(
        "Wrapper",
        WrapperModel.all(null, ForecastModel.id(forecastId),
                CategoryModel.id(1), "Transporte", 150.0)
            .toMap());
    batch.insert(
        "Wrapper",
        WrapperModel.all(null, ForecastModel.id(forecastId),
                CategoryModel.id(1), "Águla/Luz/Fone/Net", 120.0)
            .toMap());
    batch.insert(
        "Wrapper",
        WrapperModel.all(null, ForecastModel.id(forecastId),
                CategoryModel.id(1), "Moradia", 550.0)
            .toMap());

    batch.insert(
        "Wrapper",
        WrapperModel.all(null, ForecastModel.id(forecastId),
                CategoryModel.id(2), "Curso Inglês", 100.0)
            .toMap());

    batch.insert(
        "Wrapper",
        WrapperModel.all(null, ForecastModel.id(forecastId),
                CategoryModel.id(3), "Compra do carro", 400.0)
            .toMap());

    batch.insert(
        "Wrapper",
        WrapperModel.all(null, ForecastModel.id(forecastId),
                CategoryModel.id(4), "Previdência", 200.0)
            .toMap());

    batch.insert(
        "Wrapper",
        WrapperModel.all(null, ForecastModel.id(forecastId),
                CategoryModel.id(5), "Despesas Livres", 200.0)
            .toMap());
    await batch.commit();
  }
}
