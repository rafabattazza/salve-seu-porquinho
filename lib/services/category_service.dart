import 'package:salveSeuPorquinho/models/category_model.dart';
import 'package:salveSeuPorquinho/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class CategoryService {
  Future<List<CategoryModel>> findAll() async {
    final db = await DbService.db;
    List<Map<String, dynamic>> res = await db.rawQuery(" SELECT *"
        " FROM Category"
        " WHERE cat_deleted = 0"
        " ORDER BY cat_percent DESC");

    List<CategoryModel> list = res.isNotEmpty
        ? res.map((c) => CategoryModel.fromMap(c)).toList()
        : null;
    return list;
  }

  Future<CategoryModel> findById(int id) async {
    final db = await DbService.db;
    List<Map<String, dynamic>> res = await db.rawQuery(
        " SELECT *"
        " FROM Category"
        " WHERE cat_id = ?",
        [id]);

    return res.isNotEmpty ? CategoryModel.fromMap(res[0]) : null;
  }

  persist(CategoryModel category) async {
    final db = await DbService.db;
    if (category.id != null) {
      await db.update("Category", category.toMap(),
          where: "cat_id = ?", whereArgs: [category.id]);
    } else {
      int insertedId = await db.insert("Category", category.toMap());
      category.id = insertedId;
    }
  }

  Future<void> createDefaultCategory() async {
    final db = await DbService.db;
    Batch batch = db.batch();
    batch.insert("Category",
        CategoryModel.all(1, "Despesas Essenciais", 55, false).toMap());
    batch.insert(
        "Category", CategoryModel.all(2, "Educação", 5, false).toMap());
    batch.insert(
        "Category",
        CategoryModel.all(3, "Objetivos Curto/Médio/Longo Prazo", 20, false)
            .toMap());
    batch.insert(
        "Category", CategoryModel.all(4, "Aposentadoria", 10, false).toMap());
    batch.insert("Category", CategoryModel.all(5, "Livre", 10, false).toMap());
    await batch.commit();
  }
}
