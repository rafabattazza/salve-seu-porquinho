import 'package:salveSeuPorquinho/models/transac_model.dart';
import 'package:salveSeuPorquinho/screens/dashboard/entries/filter_dto.dart';
import 'package:salveSeuPorquinho/services/database/root_dao.dart';

class TransacDAO extends RootDAO {
  Future<List<TransacModel>> findByFilter(final FilterDto filter) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.rawQuery(
      " SELECT *"
      " FROM Transac "
      " INNER JOIN Wrapper ON wra_id = tra_wrapper"
      " ORDER BY tra_date DESC",
    );

    return res.isEmpty ? [] : res.map((e) => TransacModel.fromMap(e)).toList();
  }

  Future<String> findLastDescr(final int wrapperId) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.rawQuery(
        " SELECT tra_descr"
                " FROM Transac "
                " WHERE tra_wrapper = ? " +
            " ORDER BY tra_date DESC",
        [wrapperId]);

    return res.isEmpty ? null : res[0]['tra_descr'];
  }

  persist(TransacModel transaction) async {
    final db = await database;
    if (transaction.id != null) {
      await db.update("Transac", transaction.toMap(),
          where: "tra_id = ?", whereArgs: [transaction.id]);
    } else {
      int insertedId = await db.insert("Transac", transaction.toMap());
      transaction.id = insertedId;
    }
  }
}
