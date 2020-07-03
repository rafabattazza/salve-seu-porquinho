import 'package:salveSeuPorquinho/models/category_model.dart';
import 'package:salveSeuPorquinho/models/wrapper_model.dart';
import 'package:salveSeuPorquinho/services/database/root_dao.dart';

class WrapperDAO extends RootDAO {
  Future<List<WrapperModel>> findByForecast(final int forecastId) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.rawQuery(
        " SELECT *"
        " FROM Wrapper "
        " INNER JOIN Forecast ON for_id = wra_forecast "
        " WHERE wra_forecast = ? "
        " ORDER BY wra_name",
        [forecastId]);

    return res.isEmpty ? [] : res.map((e) => WrapperModel.fromMap(e)).toList();
  }

  Future<List<CategoryModel>> findByForecastGroupedByCategory(
      final int forecastId) async {
    final db = await database;

    List<Map<String, dynamic>> resCategory = await db.rawQuery(" SELECT *"
        " FROM Category "
        " WHERE cat_deleted = 0"
        " ORDER BY cat_percent DESC, cat_name");

    if (resCategory.isEmpty) return [];

    List<CategoryModel> result = [];
    for (Map<String, dynamic> mapCategory in resCategory) {
      CategoryModel category = CategoryModel.fromMap(mapCategory);

      List<Map<String, dynamic>> resWrapper = await db.rawQuery(
          " SELECT *"
          " FROM Wrapper"
          " WHERE wra_forecast = ? AND wra_category = ?"
          " ORDER BY wra_name",
          [forecastId, category.id]);

      for (Map<String, dynamic> row in resWrapper) {
        WrapperModel wrapper = WrapperModel.fromMap(row);
        wrapper.category = category;
        category.groupedWrappers.add(wrapper);
      }
      result.add(category);
    }

    return result;
  }

  persist(WrapperModel wrapper) async {
    final db = await database;
    if (wrapper.id != null) {
      await db.update("Wrapper", wrapper.toMap(),
          where: "wra_id = ?", whereArgs: [wrapper.id]);
    } else {
      int insertedId = await db.insert("Wrapper", wrapper.toMap());
      wrapper.id = insertedId;
    }
  }

  delete(WrapperModel wrapper) async {
    final db = await database;
    await db.delete("Wrapper", where: "wra_id = ?", whereArgs: [wrapper.id]);
  }

  duplicateForecast(int lastForecastId, int nextForecastId) async {
    final db = await database;
    await db.execute(
        " INSERT INTO Wrapper (wra_forecast, wra_category, wra_name, wra_budget)"
        " SELECT ?, wra_category, wra_name, wra_budget "
        " FROM Wrapper"
        " WHERE wra_forecast = ?",
        [nextForecastId, lastForecastId]);
  }
}
