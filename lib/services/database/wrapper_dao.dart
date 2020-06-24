import 'package:salveSeuPorquinho/models/wrapper_model.dart';
import 'package:salveSeuPorquinho/services/database/root_dao.dart';

class WrapperDAO extends RootDAO {
  persist(WrapperModel wrapper) async {
    final db = await database;
    print("id no persist ${wrapper.id}");
    if (wrapper.id != null) {
      await db.update("Wrappers", wrapper.toMap(), where: "wra_id = ?", whereArgs: [wrapper.id]);
    } else {
      int insertedId = await db.insert("Wrappers", wrapper.toMap());
      wrapper.id = insertedId;
    }
  }
}
