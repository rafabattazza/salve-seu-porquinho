import 'package:salveSeuPorquinho/models/category_model.dart';
import 'package:salveSeuPorquinho/models/forecast_model.dart';
import 'package:salveSeuPorquinho/models/wrapper_model.dart';
import 'package:salveSeuPorquinho/services/database/root_dao.dart';

class ForecastDAO extends RootDAO {
  Future<ForecastModel> findWithTransactionsValue(final int forecastId) async {
    final db = await database;

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
    }

    ForecastModel forecast = ForecastModel.fromMap(resCategory[0]);
    forecast.categories = categories;

    return forecast;
  }

  persist(ForecastModel forecast) async {
    final db = await database;

    if (forecast.id != null) {
      await db.update("Forecast", forecast.toMap(),
          where: "for_id = ?", whereArgs: [forecast.id]);
    } else {
      int insertedId = await db.insert("Forecast", forecast.toMap());
      forecast.id = insertedId;
    }
  }

  Future<ForecastModel> findByMonthAndYear(int month, int year) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.rawQuery(
        " SELECT *"
        " FROM Forecast"
        " WHERE for_month = ? AND for_year = ?",
        [month, year]);

    return res.isNotEmpty ? ForecastModel.fromMap(res[0]) : null;
  }

  Future<ForecastModel> findLast() async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.rawQuery(" SELECT *"
        " FROM Forecast"
        " ORDER BY for_year DESC, for_month DESC"
        " LIMIT 1");

    return res.isNotEmpty ? ForecastModel.fromMap(res[0]) : null;
  }
}
