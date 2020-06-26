import 'package:salveSeuPorquinho/models/forecast_model.dart';
import 'package:salveSeuPorquinho/services/database/root_dao.dart';

class ForecastDAO extends RootDAO {
  persist(ForecastModel forecast) async {
    final db = await database;

    if (forecast.id != null) {
      await db.update("Forecast", forecast.toMap(), where: "for_id = ?", whereArgs: [forecast.id]);
    } else {
      int insertedId = await db.insert("Forecast", forecast.toMap());
      forecast.id = insertedId;
    }
  }

  Future<ForecastModel> findByMounthAndYear(int mounth, int year) async {
    final db = await database;
    List<Map<String, dynamic>> res =
        await db.rawQuery(
          " SELECT *"
          " FROM Forecast"
          " WHERE for_mounth = ? AND for_year = ?",
          [mounth, year]
        );
    
    return res.isNotEmpty
        ? ForecastModel.fromMap(res[0])
        : null;
  }

  Future<ForecastModel> findLast() async {
    final db = await database;
    List<Map<String, dynamic>> res =
        await db.rawQuery(
          " SELECT *"
          " FROM Forecast"
          " ORDER BY for_year DESC, for_mounth DESC"
          " LIMIT 1"
        );
    
    return res.isNotEmpty
        ? ForecastModel.fromMap(res[0])
        : null;
  }
}
