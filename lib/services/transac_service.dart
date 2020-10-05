import 'package:intl/intl.dart';
import 'package:salveSeuPorquinho/models/forecast_model.dart';
import 'package:salveSeuPorquinho/models/transac_model.dart';
import 'package:salveSeuPorquinho/models/wrapper_model.dart';
import 'package:salveSeuPorquinho/screens/dashboard/entries/filter_dto.dart';
import 'package:salveSeuPorquinho/services/forecast_service.dart';
import 'package:salveSeuPorquinho/services/wrapper_service.dart';

import 'database_service.dart';

class TransacService {
  Future<List<TransacModel>> findByFilter(final FilterDto filter) async {
    final db = await DbService.db;
    List<Map<String, dynamic>> res = await db.rawQuery(
        " SELECT *"
                " FROM Transac "
                " INNER JOIN Wrapper ON wra_id = tra_wrapper"
                " WHERE strftime('%m', tra_dt_due) = ? AND strftime('%Y', tra_dt_due) = ? " +
            (filter.wrapperId != null ? " AND tra_wrapper = ? " : "") +
            " ORDER BY tra_dt_due DESC",
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
        " WHERE tra_wrapper = ? "
        " ORDER BY tra_dt_due DESC",
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
        await this._insert(transaction);
      }
    }
  }

  _insert(final TransacModel transaction) async {
    final db = await DbService.db;

    final ForecastService forecastService = new ForecastService();
    final WrapperService wrapperService = new WrapperService();

    if (transaction.dtDue.isAfter(transaction.dtCreate)) {
      WrapperModel actualWrapper = await wrapperService.findById(transaction.wrapper.id);

      ForecastModel forecast = await forecastService.loadOrCreateForecast(null, transaction.dtDue, false);
      WrapperModel newWrapper = await wrapperService.findWrapperByForecast(actualWrapper.name, forecast.id);
      if (newWrapper == null) {
        throw new Exception("Não existe previsão para a Categoria " + actualWrapper.name + " na data " + new DateFormat("MM/yyyy").format(transaction.dtDue));
      }
      transaction.wrapper = newWrapper;
    }

    int insertedId = await db.insert("Transac", transaction.toMap());
    transaction.id = insertedId;
  }

  createInstallmenteByDivide(final TransacModel transaction, final int installmentCount) async {
    final db = await DbService.db;
    double installmentValue = double.parse((transaction.value / installmentCount).toStringAsFixed(2));
    double dif = double.parse((transaction.value - (installmentValue * installmentCount)).toStringAsFixed(2));
    DateTime due = transaction.dtCreate;

    for (int i = 0; i < installmentCount; i++) {
      TransacModel installment = new TransacModel(
        dtCreate: transaction.dtCreate,
        dtDue: due,
        descr: transaction.descr + " Parc: " + (i + 1).toString() + "/" + installmentCount.toString(),
        value: i == 0 ? installmentValue + dif : installmentValue,
        wrapper: transaction.wrapper,
      );
      await this._insert(installment);

      due = new DateTime(due.year, due.month + 1, due.day);
    }
  }

  createInstallmenteByMultiply(final TransacModel transaction, final int installmentCount) async {
    final db = await DbService.db;
    DateTime due = transaction.dtCreate;
    for (int i = 0; i < installmentCount; i++) {
      TransacModel installment = new TransacModel(
        dtCreate: transaction.dtCreate,
        dtDue: due,
        descr: transaction.descr + " Parc: " + (i + 1).toString() + "/" + installmentCount.toString(),
        value: transaction.value,
        wrapper: transaction.wrapper,
      );
      await this._insert(installment);

      due = new DateTime(due.year, due.month + 1, due.day);
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

  Future<List<Map<String, dynamic>>> findByDateGroupByWrapper(final DateTime dateTime) async {
    final db = await DbService.db;
    List<Map<String, dynamic>> res = await db.rawQuery(
        " SELECT wra_name, SUM(tra_value) as tra_value "
        " FROM Transac "
        " INNER JOIN Wrapper ON wra_id = tra_wrapper"
        " WHERE strftime('%m', tra_dt_due) = ? AND strftime('%Y', tra_dt_due) = ? "
        " GROUP BY wra_name"
        " ORDER BY wra_name",
        [
          dateTime.month.toString().padLeft(2, '0'),
          dateTime.year.toString().padLeft(4, '0'),
        ]);

    return res;
  }

  Future<List<Map<String, dynamic>>> findByDateGroupByMethod(final DateTime dateTime) async {
    final db = await DbService.db;

    List<Map<String, dynamic>> res = await db.rawQuery(
        " SELECT met_name, SUM(tra_value) as tra_value "
        " FROM Transac "
        " INNER JOIN Method ON met_id = tra_method"
        " WHERE strftime('%m', tra_dt_due) = ? AND strftime('%Y', tra_dt_due) = ? "
        " GROUP BY met_name"
        " ORDER BY met_name",
        [
          dateTime.month.toString().padLeft(2, '0'),
          dateTime.year.toString().padLeft(4, '0'),
        ]);

    return res;
  }
}
