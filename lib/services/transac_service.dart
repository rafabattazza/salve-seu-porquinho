import 'package:salveSeuPorquinho/models/transac_model.dart';
import 'package:salveSeuPorquinho/screens/dashboard/entries/filter_dto.dart';

import 'database_service.dart';

class TransacService {
  Future<List<TransacModel>> findByFilter(final FilterDto filter) async {
    final db = await DbService.db;
    List<Map<String, dynamic>> res = await db.rawQuery(
        " SELECT *"
                " FROM Transac "
                " INNER JOIN Wrapper ON wra_id = tra_wrapper"
                " WHERE strftime('%m', tra_date) = ? AND strftime('%Y', tra_date) = ? " +
            (filter.wrapperId != null ? " AND tra_wrapper = ? " : "") +
            " ORDER BY tra_date DESC",
        [
          filter.monthYear.month.toString().padLeft(2, '0'),
          filter.monthYear.year.toString().padLeft(4, '0'),
          ...(filter.wrapperId != null ? [filter.wrapperId] : [])
        ]);

    return res.isEmpty ? [] : res.map((e) => TransacModel.fromMap(e)).toList();
  }

  Future<String> findLastDescr(final int wrapperId) async {
    final db = await DbService.db;
    List<Map<String, dynamic>> res = await db.rawQuery(
        " SELECT tra_descr"
                " FROM Transac "
                " WHERE tra_wrapper = ? " +
            " ORDER BY tra_date DESC",
        [wrapperId]);

    return res.isEmpty ? null : res[0]['tra_descr'];
  }

  persist(final TransacModel transaction, final int installmentCount, final int installmentOption) async {
    final db = await DbService.db;
    if (transaction.id != null) {
      await db.update("Transac", transaction.toMap(), where: "tra_id = ?", whereArgs: [transaction.id]);
    } else {
      if (installmentCount > 0 && installmentOption > 0) {
        if (installmentOption == 1) {
          await createInstallmenteByDivide(transaction, installmentCount);
        } else {
          await createInstallmenteByMultiply(transaction, installmentCount);
        }
      } else {
        int insertedId = await db.insert("Transac", transaction.toMap());
        transaction.id = insertedId;
      }
    }
  }

  createInstallmenteByDivide(final TransacModel transaction, final int installmentCount) async {
    final db = await DbService.db;
    double installmentValue = double.parse((transaction.value / installmentCount).toStringAsFixed(2));
    double dif = double.parse((transaction.value - (installmentValue * installmentCount)).toStringAsFixed(2));
    DateTime data = transaction.date;

    for (int i = 0; i < installmentCount; i++) {
      TransacModel installment = new TransacModel(
        date: data,
        descr: transaction.descr + " Parc: " + (i + 1).toString() + "/" + installmentCount.toString(),
        value: i == 0 ? installmentValue + dif : installmentValue,
        wrapper: transaction.wrapper,
      );
      await db.insert("Transac", installment.toMap());

      data = new DateTime(data.year, data.month + 1, data.day);
    }
  }

  createInstallmenteByMultiply(final TransacModel transaction, final int installmentCount) async {
    final db = await DbService.db;
    DateTime data = transaction.date;
    for (int i = 0; i < installmentCount; i++) {
      TransacModel installment = new TransacModel(
        date: data,
        descr: transaction.descr + " Parc: " + (i + 1).toString() + "/" + installmentCount.toString(),
        value: transaction.value,
        wrapper: transaction.wrapper,
      );
      await db.insert("Transac", installment.toMap());

      data = new DateTime(data.year, data.month + 1, data.day);
    }
  }

  delete(int tra_id) async {
    final db = await DbService.db;
    db.delete(
      "transac",
      where: "tra_id = ?",
      whereArgs: [tra_id],
    );
  }
}
