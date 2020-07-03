import 'package:intl/intl.dart';
import 'package:salveSeuPorquinho/models/wrapper_model.dart';
import 'package:salveSeuPorquinho/utils/utils.dart';

class TransacModel {
  int id;
  WrapperModel wrapper;
  String descr;
  double value;
  DateTime date;

  TransacModel({this.id, this.wrapper, this.descr, this.value, this.date});
  TransacModel.id(this.id);
  TransacModel.all(this.id, this.wrapper, this.descr, this.value, this.date);

  factory TransacModel.fromMap(Map<String, dynamic> json) =>
      new TransacModel.all(
        json["tra_id"],
        WrapperModel.fromMap(json),
        json["tra_descr"],
        json["tra_value"] == null ? null : json["tra_value"] + .0,
        json["tra_date"] == null
            ? null
            : Utils.dbDateFormat.parse(json["tra_date"]),
      );

  Map<String, dynamic> toMap() => {
        "tra_id": id,
        "tra_wrapper": wrapper.id,
        "tra_descr": descr,
        "tra_value": value,
        "tra_date": date == null ? null : Utils.dbDateFormat.format(date),
      };
}
