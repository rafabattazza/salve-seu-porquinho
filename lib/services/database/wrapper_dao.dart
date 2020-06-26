import 'package:salveSeuPorquinho/models/category_model.dart';
import 'package:salveSeuPorquinho/models/wrapper_model.dart';
import 'package:salveSeuPorquinho/services/database/root_dao.dart';

class WrapperDAO extends RootDAO {
  Future<List<CategoryModel>> findByForecastGroupedByCategory(final int forecastId) async {
    final db = await database;

    List<Map<String, dynamic>> res =
        await db.rawQuery(
          " SELECT *"
          " FROM Wrapper"
          " INNER JOIN Category ON cat_id = wra_category"
          " WHERE wra_forecast = ?"
          " ORDER BY cat_percent DESC, cat_name, wra_name",
          [forecastId]
        );

    if(res.isEmpty)return [];

    CategoryModel lastCategory = CategoryModel.fromMap(res[0]);
    List<CategoryModel> result = [lastCategory];
    for(Map<String, dynamic> row in res){
      CategoryModel category = CategoryModel.fromMap(row);
      if(category.id != lastCategory.id) {
        lastCategory = category;
        result.add(lastCategory);
      }
      lastCategory.groupedWrappers.add(WrapperModel.fromMap(row));
    }

    print(result);
    return result;
  }

  persist(WrapperModel wrapper) async {
    final db = await database;
    if (wrapper.id != null) {
      await db.update("Wrappers", wrapper.toMap(), where: "wra_id = ?", whereArgs: [wrapper.id]);
    } else {
      int insertedId = await db.insert("Wrappers", wrapper.toMap());
      wrapper.id = insertedId;
    }
  }
}
