import 'package:salveSeuPorquinho/models/category_model.dart';
import 'package:salveSeuPorquinho/services/database/root_dao.dart';

class CategoryDAO extends RootDAO {
  Future<List<CategoryModel>> findAll() async {
    final db = await database;
    List<Map<String, dynamic>> res =
        await db.rawQuery(
          " SELECT *"
          " FROM Category"
          " WHERE cat_deleted = 0"
          " ORDER BY cat_percent DESC");
    
    List<CategoryModel> list = res.isNotEmpty
        ? res.map((c) => CategoryModel.fromMap(c)).toList()
        : null;
    return list;
  }

  Future<CategoryModel> findById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> res =
        await db.rawQuery(
          " SELECT *"
          " FROM Category"
          " WHERE cat_id = ?",
          [id]
        );
    
    return res.isNotEmpty
        ? CategoryModel.fromMap(res[0])
        : null;
    
  }

  persist(CategoryModel category) async {
    final db = await database;
    if (category.id != null) {
      await db.update("Category", category.toMap(), where: "cat_id = ?", whereArgs: [category.id]);
    } else {
      int insertedId = await db.insert("Category", category.toMap());
      category.id = insertedId;
    }
  }
}
