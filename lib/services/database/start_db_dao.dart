import 'package:salveSeuPorquinho/models/category_model.dart';
import 'package:salveSeuPorquinho/models/prevision_model.dart';
import 'package:salveSeuPorquinho/models/wrapper_model.dart';
import 'package:salveSeuPorquinho/services/database/root_dao.dart';
import 'package:sqflite/sqflite.dart';

class StartDbDao extends RootDAO {
  startDb() async {
    final db = await database;
    int count = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM Category"));
    if(count == 0){
      Batch batch = db.batch();
      batch.insert("Category", CategoryModel.all(1, "Despesas Essenciais", 55, false).toMap());
      batch.insert("Category", CategoryModel.all(2, "Educação", 5, false).toMap());
      batch.insert("Category", CategoryModel.all(3, "Objetivos Curto/Médio/Longo Prazo", 20, false).toMap());
      batch.insert("Category", CategoryModel.all(4, "Aposentadoria", 10, false).toMap());
      batch.insert("Category", CategoryModel.all(5, "Livre", 10, false).toMap());

      batch.insert("Prevision", PrevisionModel.all(1, DateTime.now().month, DateTime.now().year, 2000.0).toMap());

      batch.insert("Wrapper", WrapperModel.all(null, PrevisionModel.id(1), CategoryModel.id(1), "Mercado", 450.0).toMap());
      batch.insert("Wrapper", WrapperModel.all(null, PrevisionModel.id(1), CategoryModel.id(1), "Lazer", 150.0).toMap());
      batch.insert("Wrapper", WrapperModel.all(null, PrevisionModel.id(1), CategoryModel.id(1), "Roupas", 100.0).toMap());
      batch.insert("Wrapper", WrapperModel.all(null, PrevisionModel.id(1), CategoryModel.id(1), "Transporte", 150.0).toMap());
      batch.insert("Wrapper", WrapperModel.all(null, PrevisionModel.id(1), CategoryModel.id(1), "Águla/Luz/Fone/Net", 120.0).toMap());
      batch.insert("Wrapper", WrapperModel.all(null, PrevisionModel.id(1), CategoryModel.id(1), "Moradia", 550.0).toMap());

      batch.insert("Wrapper", WrapperModel.all(null, PrevisionModel.id(1), CategoryModel.id(2), "Curso Inglês", 100.0).toMap());

      batch.insert("Wrapper", WrapperModel.all(null, PrevisionModel.id(1), CategoryModel.id(3), "Compra do carro", 400.0).toMap());

      batch.insert("Wrapper", WrapperModel.all(null, PrevisionModel.id(1), CategoryModel.id(4), "Previdência", 200.0).toMap());

      batch.insert("Wrapper", WrapperModel.all(null, PrevisionModel.id(1), CategoryModel.id(5), "Despesas Livres", 200.0).toMap());

      await batch.commit();
      print("insert ok");
    }
  }
}
