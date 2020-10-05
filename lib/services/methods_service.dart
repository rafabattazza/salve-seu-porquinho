import 'package:salveSeuPorquinho/models/method_model.dart';
import 'package:salveSeuPorquinho/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class MethodsService {
  Future<List<MethodModel>> findAll() async {
    final db = await DbService.db;
    List<Map<String, dynamic>> res = await db.rawQuery(" SELECT *"
        " FROM Method"
        " ORDER BY met_name");

    List<MethodModel> list = res.isNotEmpty ? res.map((c) => MethodModel.fromMap(c)).toList() : null;
    return list;
  }

  persist(MethodModel method) async {
    final db = await DbService.db;
    if (method.id != null) {
      await db.update("Method", method.toMap(), where: "met_id = ?", whereArgs: [method.id]);
    } else {
      int insertedId = await db.insert("Method", method.toMap());
      method.id = insertedId;
    }
  }

  Future<void> createDefaultMethods() async {
    final db = await DbService.db;
    Batch batch = db.batch();
    batch.insert("Method", MethodModel.all(1, "A Vista", 1, 1, 0).toMap());
    batch.insert("Method", MethodModel.all(2, "Crédito", 2, 1, 10).toMap());
    await batch.commit();
  }
}
